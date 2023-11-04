/**
 * A class for calculating hash sum in files or strings
 * using all the hash algorithms supported by Java
 *
 * @author Olaf Reitmaier
 * @version December, 2005
 */
import java.security.NoSuchAlgorithmException;
import java.security.MessageDigest;

import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedInputStream;
import java.io.IOException;

public class HashSum {

    public static final int BUFFER_SIZE = 1024; // The maximum buffer size

    private MessageDigest msgDigest; // The message digest processor
    private String hashStr; // The result sum of the digest committed with the hash algorithm

    /**
     * Creates a new hash processor
     *
     * @param algorithm The name of the algorithm (MD5, SHA-1, SHA-256, SHA-512, etc). See Java 2 documentation.
     */
    public HashSum(String algorithm) throws NoSuchAlgorithmException {
        msgDigest = MessageDigest.getInstance(algorithm);
    }

    /**
     * Calculate the hash sum of a file
     *
     * @param srcFile The file to be processed
     * @return A byte array with the hash sum value (Must be converted to Hexadecimal)
     */
    public byte[] calculate(File srcFile) throws IOException {
        boolean ready = false;
        int bytesOnBuffer = 0;
        byte[] text = null;
        FileInputStream fis = new FileInputStream(srcFile);
        msgDigest.reset(); // Initialize the hashing processor
        while (!ready) {
            bytesOnBuffer = fis.available(); // Available bytes on buffer
            if (bytesOnBuffer >= BUFFER_SIZE) { // If there are too many bytes
                text = new byte[BUFFER_SIZE]; // Create a new fixed buffer
                fis.read(text, 0, BUFFER_SIZE);
                msgDigest.update(text); // Hash
            } else {
                // If there are few bytes
                if (bytesOnBuffer > 0) { //
                    text = new byte[bytesOnBuffer]; // Create a new fixed buffer
                    fis.read(text, 0, bytesOnBuffer); // Read all the last bytes
                    msgDigest.update(text); // Hash the last bytes
                }
                ready = true;
            }
        }
        fis.close();
        if (ready) {
            return msgDigest.digest(); // Final operations (padding)
        } else {
            return null; // No digest was done!!!
        }
    }

    /**
     * Calculate the hash sum of a string
     *
     * @param str The string to be processed
     * @return A byte array with the hash sum value (Must be converted to Hexadecimal)
     */
    public byte[] calculate(String str) {
        msgDigest.reset();
        msgDigest.update(str.getBytes());
        return msgDigest.digest();
    }

    /**
     * Converts the byte array to string (Version #1)
     *
     * @param bytes The byte array
     * @return A lower case string in hexadecimal notation
     */
    public static String toHexString1(byte[] bytes) {
        StringBuffer sb = new StringBuffer();
        String s = null;
        for (int i = 0; i < bytes.length; i++) {
            s = Integer.toHexString(bytes[i] & 0xFF);
            if (s.length() < 2) s = "0" + s;
            if (s.length() > 2) s = s.substring(s.length() - 2);
            sb.append(s);
        }
        return sb.toString();
    }

    /**
     * Converts the byte array to string (Version #2)
     *
     * @param bytes The byte array
     * @return A lower case string in hexadecimal notation
     */
    public static String toHexString2(byte[] bytes) {
        String HEX_DIGITS = "0123456789abcdef";
        StringBuffer sb = new StringBuffer(bytes.length * 2);
        int bValue = 0;
        for (int i = 0; i < bytes.length; i++) {
            bValue = bytes[i] & 0xFF;
            sb.append(HEX_DIGITS.charAt(bValue >>> 4)).append(HEX_DIGITS.charAt(bValue & 0xF));
        }
        return sb.toString();
    }
}
