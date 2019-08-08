#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Exit the script with as failed with an optional error message.
#
# Arguments:
#   $1 Error message (optional)
# ------------------------------------------------------------------------------
function ::exit.nok() {
    local message=${1:-}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if ::var.has_value "${message}"; then
        ::log.fatal "${message}"
    fi

    exit "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Exit the script when given value is false, with an optional error message.
#
# Arguments:
#   $1 Value to check if false
#   $2 Error message (optional)
# ------------------------------------------------------------------------------
function ::exit.die_if_false() {
    local value=${1:-}
    local message=${2:-}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if ::var.false "${value}"; then
        ::exit.nok "${message}"
    fi
}


# ------------------------------------------------------------------------------
# Exit the script when given value is true, with an optional error message.
#
# Arguments:
#   $1 Value to check if true
#   $2 Error message (optional)
# ------------------------------------------------------------------------------
function hass.die_if_true() {
    local value=${1:-}
    local message=${2:-}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if ::var.true "${value}"; then
        ::exit.nok "${message}"
    fi
}

# ------------------------------------------------------------------------------
# Exit the script when given value is empty, with an optional error message.
#
# Arguments:
#   $1 Value to check if true
#   $2 Error message (optional)
# ------------------------------------------------------------------------------
function hass.die_if_empty() {
    local value=${1:-}
    local message=${2:-}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if ::var.is_empty "${value}"; then
        ::exit.nok "${message}"
    fi
}

# ------------------------------------------------------------------------------
# Exit the script nicely.
# ------------------------------------------------------------------------------
function ::exit.ok() {
    ::log.trace "${FUNCNAME[0]}" "$@"
    exit "${__BASHLIB_EXIT_OK}"
}