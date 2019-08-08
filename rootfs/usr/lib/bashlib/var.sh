#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Checks if a give value is true.
#
# Arguments:
#   $1 value
# ------------------------------------------------------------------------------
function ::var.true() {
    local value=${1:-null}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ "${value}" = "true" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Checks if a give value is false.
#
# Arguments:
#   $1 value
# ------------------------------------------------------------------------------
function ::var.false() {
    local value=${1:-null}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ "${value}" = "false" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Checks if a global variable is defined.
#
# Arguments:
#   $1 Name of the variable
# ------------------------------------------------------------------------------
::var.defined() {
    local variable=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    [[ "${!variable-X}" = "${!variable-Y}" ]]
}

# ------------------------------------------------------------------------------
# Checks if a value has actual value.
#
# Arguments:
#   $1 Value
# ------------------------------------------------------------------------------
function ::var.has_value() {
    local value=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ -n "${value}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Checks if a value is empty.
#
# Arguments:
#   $1 Value
# ------------------------------------------------------------------------------
function ::var.is_empty() {
    local value=${1}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ -z "${value}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Checks if a value equals.
#
# Arguments:
#   $1 Value
#   $2 Equals value
# ------------------------------------------------------------------------------
function ::var.equals() {
    local value=${1}
    local equals=${2}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ "${value}" = "${equals}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

function ::var.less_than() {
    local value_a=${1}
    local value_b=${2}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ "${value_a}" -lt "${value_b}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}

function ::var.greater_than() {
    local value_a=${1}
    local value_b=${2}

    ::log.trace "${FUNCNAME[0]}:" "$@"

    if [[ "${value_a}" -gt "${value_b}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    return "${__BASHLIB_EXIT_NOK}"
}