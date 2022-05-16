#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/grafana/cortex-tools/releases/download

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="cortextool_${ver}_${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1

    # https://github.com/grafana/cortex-tools/releases/download/v0.10.7/checksums.txt
    local url="$MIRROR/v$ver/checksums.txt"
    local lchecksums="$DIR/cortextools_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums darwin arm64
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums windows i386 zip
    dl $ver $lchecksums windows x86_64 zip
}

dl_ver ${1:-0.10.7}
