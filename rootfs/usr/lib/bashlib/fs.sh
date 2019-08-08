#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Check whether or not a directory exists.
#
# Arguments:
#   $1 Path to directory
# ------------------------------------------------------------------------------
function ::fs.directory_exists() {
    local directory=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ -d "${directory}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Check whether or not a file exists.
#
# Arguments:
#   $1 Path to file
# ------------------------------------------------------------------------------
function ::fs.file_exists() {
    local file=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ -f "${file}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Check whether or not a device exists.
#
# Arguments:
#   $1 Path to device
# ------------------------------------------------------------------------------
function ::fs.device_exists() {
    local device=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ -d "${device}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Check whether or not a socket exists.
#
# Arguments:
#   $1 Path to socket
# ------------------------------------------------------------------------------
function ::fs.socket_exists() {
    local socket=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ -S "${socket}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}
