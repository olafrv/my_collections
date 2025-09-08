#!/bin/bash

###
# Pre-Requisites (no need to be root):
# * pkgx: https://github.com/pkgxdev/pkgx
#   => Install: curl https://pkgx.sh | sh
# * huggingface-cli: https://huggingface.co/docs/huggingface_hub/main/en/guides/cli
#   => Install: pkgx install huggingface-cli
##

HF_URL="$1"
HF_ROOT_DIR="/volume2/public/huggingface"
# https://github.com/huggingface/huggingface_hub/pull/2500/files
HF_MAX_WORKERS=1

# Check if URL parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <huggingface_repo_url>"
  exit 1
fi

# Extract the repo path from the HF URL: username/reponame
# Examples:
# - https://huggingface.co/XuminYu/example_safetensors
# - https://huggingface.co/XuminYu/example_safetensors/tree/main
# We want to extract "XuminYu/example_safetensors"

# Better to capture username/reponame (first two path segments)
repo_path=$(echo "$HF_URL" | sed -E 's|https://huggingface.co/([^/]+/[^/]+).*|\1|')

# Replace slash with underscore for local dir
local_dir="${repo_path/\//_}"

# Run pkgx download command
cd $HF_ROOT_DIR && \
	pkgx huggingface-cli download "$repo_path" --local-dir "$local_dir" --repo-type model --max-workers $HF_MAX_WORKERS

