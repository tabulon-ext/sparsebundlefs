#!/usr/bin/env testrunner.sh

source "$(dirname "$0")/testhelpers.sh"

function setup() {
    read -r mount_dir dmg_file < <(mount_sparsebundle)
}

function test_dmg_has_expected_size() {
    size=$(ls -dn $dmg_file | awk '{print $5; exit}')
    test $size -eq 1099511627776
}

function test_dmg_has_correct_owner() {
    owner=$(ls -l $dmg_file | awk '{print $3; exit}')
    test $owner = $(whoami)
}

function test_dmg_has_correct_permissions() {
    permissions=$(ls -l $dmg_file | awk '{print $1; exit}')
    test $permissions = "-r--------"
}

function test_dmg_permissions_reflect_allow_other() {
    local mount_dir
    local dmg_file
    read -r mount_dir dmg_file < <(mount_sparsebundle -o allow_other)
    permissions=$(ls -l $dmg_file | awk '{print $1; exit}')
    test $permissions = "-r-----r--"
    umount $mount_dir && rm -Rf $mount_dir
}

function teardown() {
    umount $mount_dir && rm -Rf $mount_dir
}
