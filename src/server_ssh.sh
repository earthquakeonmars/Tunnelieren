# shellcheck shell=bash

# TUNNELIEREN_USER is supplied by the caller and checked by check_env_variables.
# shellcheck disable=SC2154
server_ssh() {
    ssh \
        -T \
        -S none \
        -o BatchMode=yes \
        -o ConnectTimeout=5 \
        -o IdentitiesOnly=yes \
        -o PreferredAuthentications=publickey \
        -i "${TUNNELIEREN_KEY}" \
        -p "${TUNNELIEREN_SERVER_PORT}" \
        -l "${TUNNELIEREN_USER}" \
        -- "${TUNNELIEREN_SERVER_IP}" "$@"
}
