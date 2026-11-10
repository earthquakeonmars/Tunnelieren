# shellcheck shell=bash

# shellcheck disable=SC2154
is_server_reachable() {
    if server_ssh true </dev/null >/dev/null; then
        return 0
    fi

    printf 'Error: SSH check failed for %s@%s:%s\n' \
        "${TUNNELIEREN_USER}" "${TUNNELIEREN_SERVER_IP}" "${TUNNELIEREN_SERVER_PORT}" >&2
    return 1
}
