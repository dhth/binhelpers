#!/usr/bin/env sh

set -e
set -o pipefail

GREEN='\033[0;32m'
RED='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'

if [ $# -ne 4 ]; then
    echo "Usage: $0 <repo> <release_version> <os> <arch>"
    exit 1
fi

repo=$1
repo_url="https://github.com/dhth/$repo"
release_version=$2
os=$3
arch=$4

temp_dir=$(mktemp -d)
if [ ! -e ${temp_dir} ]; then
    echo "Failed to create temporary directory."
    exit 1
fi

binary_name="${repo}_${release_version}_${os}_${arch}"
cosign_pub_file="cosign.pub"
checksum_file="${repo}_${release_version}_checksums.txt"
checksum_sig_file="${checksum_file}.sig"
binary_file="${binary_name}.tar.gz"

echo "${ORANGE}binary_name: ${binary_name}${NC}"
echo "${ORANGE}cosign_pub_file: ${cosign_pub_file}${NC}"
echo "${ORANGE}checksum_file: ${checksum_file}${NC}"
echo "${ORANGE}checksum_sig_file: ${checksum_sig_file}${NC}"
echo "${ORANGE}binary_file: ${binary_file}${NC}"
echo "\n---\n"

cosign_pub_url="${repo_url}/releases/download/v${release_version}/${cosign_pub_file}"
checksum_file_url="${repo_url}/releases/download/v${release_version}/${checksum_file}"
checksum_sig_file_url="${repo_url}/releases/download/v${release_version}/${checksum_sig_file}"
binary_url="${repo_url}/releases/download/v${release_version}/${binary_file}"

echo "${ORANGE}👉 Downloading assets${NC}"

curl --fail -sSL ${cosign_pub_url} -o ${temp_dir}/${cosign_pub_file}
curl --fail -sSL ${checksum_file_url} -o ${temp_dir}/${checksum_file}
curl --fail -sSL ${checksum_sig_file_url} -o ${temp_dir}/$checksum_sig_file
curl --fail -sSL ${binary_url} -o ${temp_dir}/${binary_file}

echo "\n---\n"
echo "${ORANGE}👉 Validating signature on checksums.txt${NC}\n"

echo "cosign verify-blob --key ${temp_dir}/${cosign_pub_file} --signature ${temp_dir}/$checksum_sig_file ${temp_dir}/${checksum_file}"
cosign verify-blob --key ${temp_dir}/${cosign_pub_file} --signature ${temp_dir}/$checksum_sig_file ${temp_dir}/${checksum_file}

if [ $? -ne 0 ]; then
    echo "${RED}Checksum file signature verification failed!${NC}"
    exit 1
else
    echo "${GREEN}Checksum file signature verification succeeded!${NC}"
fi

echo "\n---\n"
echo "${ORANGE}👉 Validating checksum of binary${NC}\n"
echo "$(cat ${temp_dir}/${checksum_file} | grep ${binary_file} | awk '// {print $1}')  ${temp_dir}/${binary_file}" | sha256sum -c

if [ $? -ne 0 ]; then
    echo "${RED}Binary checksum verification failed!${NC}"
    exit 1
else
    echo "${GREEN}Binary checksum verification succeeded!${NC}"
fi

tar -xzf ${temp_dir}/${binary_file} -C ${temp_dir}/
cp "${temp_dir}/$repo" .

rm -r ${temp_dir}

echo "\n---\n"
echo "${GREEN}👉 Downloaded binary: ./${repo} ${NC}"
