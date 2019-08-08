#!/usr/bin/env bash
set -o errexit  # Exit script when a command exits with non-zero status
set -o errtrace # Exit on error inside any functions or sub-shells
set -o nounset  # Exit script on use of an undefined variable
set -o pipefail # Return exit status of the last command in the pipe that failed

readonly BASHLIB_VERSION="0.1.0"

readonly __BASHLIB_LIB_DIR=$(dirname "${BASH_SOURCE[0]}")

source "${__BASHLIB_LIB_DIR}/const.sh"

declare __BASHLIB_LOG_LEVEL=${LOG_LEVEL:-${__BASHLIB_DEFAULT_LOG_LEVEL}}
declare __BASHLIB_LOG_FORMAT=${LOG_FORMAT:-${__BASHLIB_DEFAULT_LOG_FORMAT}}
declare __BASHLIB_LOG_TIMESTAMP=${LOG_TIMESTAMP:-${__BASHLIB_DEFAULT_LOG_TIMESTAMP}}

source "${__BASHLIB_LIB_DIR}/log.sh"
source "${__BASHLIB_LIB_DIR}/fs.sh"
source "${__BASHLIB_LIB_DIR}/var.sh"
source "${__BASHLIB_LIB_DIR}/exit.sh"
