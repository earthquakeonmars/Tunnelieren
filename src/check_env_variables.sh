# shellcheck shell=bash

check_env_variables() {
    local var octet
    local status=0
    local ipv4_valid=0
    local -a required_vars=(
        TUNNELIEREN_KEY
        TUNNELIEREN_SERVER_IP
        TUNNELIEREN_SERVER_PORT
        TUNNELIEREN_USER
    )

    TUNNELIEREN_SERVER_IP="${TUNNELIEREN_SERVER_IP-}"
    TUNNELIEREN_SERVER_IP="${TUNNELIEREN_SERVER_IP#"${TUNNELIEREN_SERVER_IP%%[![:space:]]*}"}"
    TUNNELIEREN_SERVER_IP="${TUNNELIEREN_SERVER_IP%"${TUNNELIEREN_SERVER_IP##*[![:space:]]}"}"

    for var in "${required_vars[@]}"; do
        if [[ -z "${!var-}" ]]; then
            echo "Error: variable '${var}' is empty or unset" >&2
            status=1
        fi
    done

    if [[ -n "${TUNNELIEREN_SERVER_IP}" ]]; then
        if [[ ${TUNNELIEREN_SERVER_IP} =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
            ipv4_valid=1
            for octet in "${BASH_REMATCH[@]:1}"; do
                if ((10#${octet} > 255)); then
                    ipv4_valid=0
                    break
                fi
            done
        fi

        if ((! ipv4_valid)); then
            echo "Error: variable 'TUNNELIEREN_SERVER_IP' must be a valid IPv4 address" >&2
            status=1
        fi
    fi

    if [[ -n "${TUNNELIEREN_SERVER_PORT-}" ]]; then
        if [[ ! ${TUNNELIEREN_SERVER_PORT} =~ ^0*([1-9][0-9]{0,4})$ ]] ||
            ((BASH_REMATCH[1] > 65535)); then
            echo "Error: variable 'TUNNELIEREN_SERVER_PORT' must be an integer between 1 and 65535" >&2
            status=1
        fi
    fi

    if [[ -n "${TUNNELIEREN_KEY-}" && ! -f "${TUNNELIEREN_KEY}" ]]; then
        echo "Error: variable 'TUNNELIEREN_KEY' must point to an existing regular file" >&2
        status=1
    fi

    return "${status}"
}
