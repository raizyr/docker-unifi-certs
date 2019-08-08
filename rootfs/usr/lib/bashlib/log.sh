#!/usr/bin/env bash

function ::log.log() {
    local level=${1}
    local message=${2}
    local timestamp
    local output

    if [[ "${level}" -gt "${__BASHLIB_LOG_LEVEL}" ]]; then
        return "${__BASHLIB_EXIT_OK}"
    fi

    timestamp=$(date +%T)
    output="[{TIMESTAMP}] {LEVEL}: {MESSAGE}\n"
    output="${output//\{TIMESTAMP\}/${timestamp}}"
    output="${output//\{MESSAGE\}/${message}}"
    output="${output//\{LEVEL\}/${__BASHLIB_LOG_LEVELS[$level]}}"

    printf "${output}" >&2

    return "${__BASHLIB_EXIT_OK}"
}

function ::log.debug() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_DEBUG}" "${message}"
}

function ::log.error() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_ERROR}" "${message}"
}

function ::log.fatal() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_FATAL}" "${message}"
}

function ::log.info() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_INFO}" "${message}"
}

function ::log.notice() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_NOTICE}" "${message}"
}

function ::log.trace() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_TRACE}" "${message}"
}

function ::log.warning() {
    local message=$*
    ::log.log "${__BASHLIB_LOG_LEVEL_WARNING}" "${message}"
}
