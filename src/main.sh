#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

main() {
    local script_dir
    script_dir=$(dirname -- "${BASH_SOURCE[0]}") || return 1

    # shellcheck source=check_utils_installed.sh
    source "${script_dir}/check_utils_installed.sh" || return 1
    # shellcheck source=check_env_variables.sh
    source "${script_dir}/check_env_variables.sh" || return 1
    # shellcheck source=server_ssh.sh
    source "${script_dir}/server_ssh.sh" || return 1
    # shellcheck source=is_server_reachable.sh
    source "${script_dir}/is_server_reachable.sh" || return 1
    # shellcheck source=acquire_lock.sh
    source "${script_dir}/acquire_lock.sh" || return 1
    # shellcheck source=create_tun.sh
    source "${script_dir}/create_tun.sh" || return 1

    check_utils_installed || return 1
    check_env_variables || return 1
    create_tun || return 1
    return 0
}

main "$@"
