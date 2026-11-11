# shellcheck shell=bash

acquire_lock() (
    local lock_path=$1 location=$2 timestamp temporary_file

    if ! timestamp=$(date +%s) || ! temporary_file=$(mktemp -- "${lock_path}.XXXXXX"); then
        printf 'Error: could not prepare the lock on %s\n' "${location}" >&2
        return 1
    fi
    trap 'rm -f -- "${temporary_file}"' EXIT

    # Publish the complete file without replacing an existing lock.
    if printf '%s\n' "${timestamp}" >"${temporary_file}" &&
        chmod 700 -- "${temporary_file}" &&
        ln -T -- "${temporary_file}" "${lock_path}" 2>/dev/null; then
        return 0
    fi

    if [[ -e "${lock_path}" || -L "${lock_path}" ]]; then
        printf 'Error: tunnelieren is already running on %s. Stop the current instance before starting another.\n' \
            "${location}" >&2
    else
        printf 'Error: could not create %s on %s\n' "${lock_path}" "${location}" >&2
    fi
    return 1
)
