# binhelpers

This repo contains helper scripts for binaries released by me.

## Downloading and validating the integrity of binaries

Say, you want to download the binary for version `0.4.3` [omm][1] for `linux`.

```bash
./getbin.sh omm 0.4.3 linux amd64
```

```text
binary_name: omm_0.4.3_linux_amd64
cosign_pub_file: cosign.pub
checksum_file: omm_0.4.3_checksums.txt
checksum_sig_file: omm_0.4.3_checksums.txt.sig
binary_file: omm_0.4.3_linux_amd64.tar.gz

---

👉 Downloading assets

---

👉 Validating signature on checksums.txt

cosign verify-blob --key /var/folders/pj/sfbmtnv51p54jwwjjv79gjp00000gq/T/tmp.m9GqoFFo9Q/cosign.pub --signature /var/folders/pj/sfbmtnv51p54jwwjjv79gjp00000gq/T/tmp.m9GqoFFo9Q/omm_0.4.3_checksums.txt.sig /var/folders/pj/sfbmtnv51p54jwwjjv79gjp00000gq/T/tmp.m9GqoFFo9Q/omm_0.4.3_checksums.txt
Verified OK
Checksum file signature verification succeeded!

---

👉 Validating checksum of binary

/var/folders/pj/sfbmtnv51p54jwwjjv79gjp00000gq/T/tmp.m9GqoFFo9Q/omm_0.4.3_linux_amd64.tar.gz: OK
Binary checksum verification succeeded!

---

👉 Downloaded binary: ./omm
```

[1]: https://github.com/dhth/omm
