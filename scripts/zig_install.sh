#!/bin/zsh

echo "Setting up zig..."
ZIG_DOWNLOADS="https://ziglang.org/download/index.json"
ZLS_REPO=""

ZIG_PATH="$HOME/bin/zig"
ZIG_TMP="$HOME/bin/zig_tmp"
ZLS_PATH="$HOME/bin/zls"

# ZIG version
# Get json of configs

    # "x86_64-linux": {
    #   "tarball": "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.3026+c225b780e.tar.xz",
    #   "shasum": "7ed6e93bd7fad21aff3fd4acd9c5eb16e55c58c0311628dfe15eae60ed04c455",
    #   "size": "48831808"
    # },
    # "aarch64-linux": {
    #   "tarball": "https://ziglang.org/builds/zig-linux-aarch64-0.14.0-dev.3026+c225b780e.tar.xz",
    #   "shasum": "cb4ccdfcfb61f7bea4d6089cbd843d2fe5cfff739c7b485f631942920a301249",
    #   "size": "44691708"
target=""
echo "Setting os type for zig..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    target="aarch64-macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    target="aarch64-linux"
else
    echo "Can't install zig because of os, exiting"
    exit 1
fi

# TODO: get correct version of zig
echo "Using target $target"

info=$(curl "$ZIG_DOWNLOADS" | jq '.master."'"$target"'"')
checksum=$(echo "$info" | jq -r ".checksum")

download_url=$(echo "$info" | jq -r ".tarball")
# Check checksum against latest
# Download if new
wget "$download_url" -O "$CONFIG/zig.tar.xz"
mkdir -p "$ZIG_TMP"
tar -xzvf "$ZIG_TMP/zig.tar.xz" -C "$ZIG_TMP" --strip-components 1
$ZIG_TMP/zig version # Verify
rm -r "$ZIG_TMP/zig.tar.xz"
rm -r $ZIG_PATH
mv $ZIG_TMP $ZIG_PATH

# Unzip tarball
# Move into directory
# Remove tarball

# ZLS version
# Initial directory install, otherwise 
cd "$ZLS_PATH"
git pull
zig build -Doptimize=ReleaseSafe

echo "Zig setup complete"