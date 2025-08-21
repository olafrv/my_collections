"""
Folder Compare Tool

This script compares two folders and identifies duplicate files based on MD5 hash comparison.
It creates a SQLite database to store file hashes and generates a CSV report of matching files.

Features:
- Recursively scans two folder structures
- Calculates MD5 hashes for all files (excluding specified extensions)
- Stores results in SQLite database with tables for hashes and matches
- Exports matching files to CSV format
- Handles Unicode file paths safely

Usage:
    python folder_compare.py folder_a folder_b [options]
    
    folder_a and folder_b are required command-line arguments specifying the directories to compare.
    The script generates:
    - file_hashes.db: SQLite database with file hashes and matches (or custom filename with --output-db)
    - file_matches.csv: CSV report of duplicate files found (or custom filename with --output-csv)

Dependencies:
    - os, hashlib, sqlite3 (standard library)
    - codecs, csv, argparse (standard library)

Author: olafrv@gmail.com
Date: August 21, 2025
"""

import os, hashlib, sqlite3
import codecs
import csv
import argparse

EXCLUDED_EXTS = {'.ini', '.js', '.css'}

def md5(file):  # Efficient MD5
    h = hashlib.md5()
    with open(file, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''): h.update(chunk)
    return h.hexdigest()

def store_hashes(folder, cur):
    for root, _, files in os.walk(folder):
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext in EXCLUDED_EXTS:
                continue  # Skip excluded extensions
            
            root_path = codecs.decode(root.encode('unicode_escape'), 'utf-8')
            path = os.path.normpath(os.path.abspath(os.path.join(root, f)))
            safe_path = codecs.decode(path.encode('unicode_escape'), 'utf-8')
            h = md5(path)
            cur.execute("INSERT INTO hashes VALUES (?,?,?,?)", (h, root_path, safe_path, f))

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Compare two folders and identify duplicate files based on MD5 hash comparison.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  python folder_compare.py /path/to/folder1 /path/to/folder2
  python folder_compare.py "C:\\Users\\user\\Documents\\Old" "C:\\Users\\user\\Documents\\New"
  python folder_compare.py folder1 folder2 --exclude-ext .log .tmp --output-csv duplicates.csv
        '''
    )
    
    parser.add_argument('folder_a', 
                       help='Path to the first folder to compare')
    parser.add_argument('folder_b', 
                       help='Path to the second folder to compare')
    parser.add_argument('--exclude-ext', 
                       nargs='*', 
                       default=['.ini', '.js', '.css'],
                       help='File extensions to exclude from comparison (default: .ini .js .css)')
    parser.add_argument('--output-db', 
                       default='file_hashes.db',
                       help='Output SQLite database filename (default: file_hashes.db)')
    parser.add_argument('--output-csv', 
                       default='file_matches.csv',
                       help='Output CSV filename (default: file_matches.csv)')
    
    args = parser.parse_args()
    
    # Validate input folders
    if not os.path.exists(args.folder_a):
        print(f"Error: Folder '{args.folder_a}' does not exist.")
        return 1
    if not os.path.exists(args.folder_b):
        print(f"Error: Folder '{args.folder_b}' does not exist.")
        return 1
    if not os.path.isdir(args.folder_a):
        print(f"Error: '{args.folder_a}' is not a directory.")
        return 1
    if not os.path.isdir(args.folder_b):
        print(f"Error: '{args.folder_b}' is not a directory.")
        return 1
    
    print(f"Comparing folders:")
    print(f"  Folder A: {args.folder_a}")
    print(f"  Folder B: {args.folder_b}")
    print(f"  Excluded extensions: {args.exclude_ext}")
    print(f"  Output database: {args.output_db}")
    print(f"  Output CSV: {args.output_csv}")
    print()

    # Update global EXCLUDED_EXTS with user-provided extensions
    global EXCLUDED_EXTS
    EXCLUDED_EXTS = set(args.exclude_ext)
    
    db = sqlite3.connect(args.output_db)
    cur = db.cursor()
    cur.execute("DROP TABLE IF EXISTS hashes")
    cur.execute("DROP TABLE IF EXISTS matches")
    cur.execute("CREATE TABLE hashes (hash TEXT, rootpath TEXT, filepath TEXT, filename TEXT)")
    cur.execute("CREATE TABLE matches (hash_a TEXT, path_a TEXT, hash_b TEXT, path_b TEXT)")

    # Store all hashes
    store_hashes(args.folder_a, cur)
    store_hashes(args.folder_b, cur)
    db.commit()

    # Convert paths to absolute paths for matching
    abs_path_a = os.path.abspath(args.folder_a)
    abs_path_b = os.path.abspath(args.folder_b)
    safe_path_a = codecs.decode(abs_path_a.encode('unicode_escape'), 'utf-8')
    safe_path_b = codecs.decode(abs_path_b.encode('unicode_escape'), 'utf-8')

    # Find matches
    cur.execute("""SELECT h1.hash, h1.filepath, h2.hash, h2.filepath 
                   FROM hashes h1 
                   JOIN hashes h2 ON h1.hash = h2.hash 
                   WHERE h1.rootpath <> h2.rootpath
                   AND h1.filepath LIKE ? AND h2.filepath LIKE ?""", 
                (f"{safe_path_a}%", f"{safe_path_b}%"))
    matches = cur.fetchall()

    with open(args.output_csv, "w", newline='', encoding="utf-8") as f:
        writer = csv.writer(f, quoting=csv.QUOTE_ALL)
        writer.writerow(["#", "File A", "File B"])  # Header

        for i, m in enumerate(matches, start=1):
            writer.writerow([i, m[1], m[3]])

    cur.executemany("INSERT INTO matches VALUES (?,?,?,?)", matches)
    db.commit()
    db.close()
    
    print(f"Found {len(matches)} matching files.")
    print(f"Results saved to:")
    print(f"  Database: {args.output_db}")
    print(f"  CSV report: {args.output_csv}")
    
    return 0

if __name__ == "__main__":
    exit(main())