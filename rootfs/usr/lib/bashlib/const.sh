#!/usr/bin/env bash

# Defaults
readonly __BASHLIB_DEFAULT_LOG_LEVEL=5 # Defaults to INFO
readonly __BASHLIB_DEFAULT_LOG_FORMAT="[{TIMESTAMP}] {LEVEL}: {MESSAGE}"
readonly __BASHLIB_DEFAULT_LOG_TIMESTAMP="%T"

# Exit codes
readonly __BASHLIB_EXIT_OK=0    # Successful termination
readonly __BASHLIB_EXIT_NOK=1   # Termination with errors

# Log levels
readonly __BASHLIB_LOG_LEVEL_ALL=8
readonly __BASHLIB_LOG_LEVEL_DEBUG=6
readonly __BASHLIB_LOG_LEVEL_ERROR=2
readonly __BASHLIB_LOG_LEVEL_FATAL=1
readonly __BASHLIB_LOG_LEVEL_INFO=5
readonly __BASHLIB_LOG_LEVEL_NOTICE=4
readonly __BASHLIB_LOG_LEVEL_OFF=0
readonly __BASHLIB_LOG_LEVEL_TRACE=7
readonly __BASHLIB_LOG_LEVEL_WARNING=3
readonly -A __BASHLIB_LOG_LEVELS=(
    [${__BASHLIB_LOG_LEVEL_OFF}]="OFF"
    [${__BASHLIB_LOG_LEVEL_FATAL}]="FATAL"
    [${__BASHLIB_LOG_LEVEL_ERROR}]="ERROR"
    [${__BASHLIB_LOG_LEVEL_WARNING}]="WARNING"
    [${__BASHLIB_LOG_LEVEL_NOTICE}]="NOTICE"
    [${__BASHLIB_LOG_LEVEL_INFO}]="INFO"
    [${__BASHLIB_LOG_LEVEL_DEBUG}]="DEBUG"
    [${__BASHLIB_LOG_LEVEL_TRACE}]="TRACE"
    [${__BASHLIB_LOG_LEVEL_ALL}]="ALL"
)

# Colors
readonly __BASHLIB_COLORS_ESCAPE="\033[";
readonly __BASHLIB_COLORS_RESET="${__BASHLIB_COLORS_ESCAPE}0m"
readonly __BASHLIB_COLORS_DEFAULT="${__BASHLIB_COLORS_ESCAPE}39m"
readonly __BASHLIB_COLORS_BLACK="${__BASHLIB_COLORS_ESCAPE}30m"
readonly __BASHLIB_COLORS_RED="${__BASHLIB_COLORS_ESCAPE}31m"
readonly __BASHLIB_COLORS_GREEN="${__BASHLIB_COLORS_ESCAPE}32m"
readonly __BASHLIB_COLORS_YELLOW="${__BASHLIB_COLORS_ESCAPE}33m"
readonly __BASHLIB_COLORS_BLUE="${__BASHLIB_COLORS_ESCAPE}34m"
readonly __BASHLIB_COLORS_MAGENTA="${__BASHLIB_COLORS_ESCAPE}35m"
readonly __BASHLIB_COLORS_CYAN="${__BASHLIB_COLORS_ESCAPE}36m"
readonly __BASHLIB_COLORS_LIGHT_GRAY="${__BASHLIB_COLORS_ESCAPE}37m"
readonly __BASHLIB_COLORS_BG_DEFAULT="${__BASHLIB_COLORS_ESCAPE}49m"
readonly __BASHLIB_COLORS_BG_BLACK="${__BASHLIB_COLORS_ESCAPE}40m"
readonly __BASHLIB_COLORS_BG_RED="${__BASHLIB_COLORS_ESCAPE}41m"
readonly __BASHLIB_COLORS_BG_GREEN="${__BASHLIB_COLORS_ESCAPE}42m"
readonly __BASHLIB_COLORS_BG_YELLOW="${__BASHLIB_COLORS_ESCAPE}43m"
readonly __BASHLIB_COLORS_BG_BLUE="${__BASHLIB_COLORS_ESCAPE}44m"
readonly __BASHLIB_COLORS_BG_MAGENTA="${__BASHLIB_COLORS_ESCAPE}45m"
readonly __BASHLIB_COLORS_BG_CYAN="${__BASHLIB_COLORS_ESCAPE}46m"
readonly __BASHLIB_COLORS_BG_WHITE="${__BASHLIB_COLORS_ESCAPE}47m"