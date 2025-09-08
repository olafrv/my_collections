#!/bin/bash

###
# Pre-Requisites (no need to be root):
# https://synocommunity.com/#easy-install (Python 3.12)
# python3.12 -m venv312
# source venv312/bin/activate
# pip install --upgrade pip
# pip install modelscope
###

MS_URL="$1"
MS_ROOT_DIR="/volume2/public/modelscope"

# Check if URL parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <modelscope_repo_url>"
  exit 1
fi

# Example:
# https://www.modelscope.cn/models/microsoft/VibeVoice-7B/files

# Capture username/reponame (first two path segments)
repo_path=$(echo "$MS_URL" | sed -E 's|https://www.modelscope.cn/models/([^/]+/[^/]+).*|\1|')

# Replace slash with underscore for local dir
local_dir="${repo_path/\//_}"

# Run pkgx download command
cd $MS_ROOT_DIR && modelscope download --model "$repo_path" --local_dir "$local_dir"

