# shellcheck shell=bash

check_utils_installed() {
    local var
    local status=0
    local -a required_utils=(
        ssh
        ip
        autossh
    )

    for var in "${required_utils[@]}"; do
        if ! command -v "${var}" &>/dev/null; then
            echo "Error: '${var}' is not found" >&2
            status=1
        fi
    done

    return "${status}"
}
