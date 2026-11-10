# shellcheck shell=bash

create_tun() {
    local lock_path=/tmp/tunnelieren.lock
    local ssh_status=0

    if ip link show dev tunnelieren &>/dev/null; then
        echo "Error: interface 'tunnelieren' already exists" >&2
        return 1
    fi

    {
        declare -f acquire_lock
        printf 'acquire_lock %q server\n' "${lock_path}"
    } | server_ssh bash -s || ssh_status=$?

    if ((ssh_status == 255)); then
        # Both variables are checked by check_env_variables before create_tun runs.
        # shellcheck disable=SC2154
        printf 'Error: SSH connection failed for %s:%s\n' \
            "${TUNNELIEREN_SERVER_IP}" "${TUNNELIEREN_SERVER_PORT}"
        return 1
    fi
    if ((ssh_status != 0)); then
        return 1
    fi

    if ! acquire_lock "${lock_path}" 'the local machine'; then
        if ! server_ssh rm -f -- "${lock_path}" </dev/null; then
            printf 'Error: could not remove %s from the server\n' "${lock_path}" >&2
        fi
        return 1
    fi

    return 0
}
