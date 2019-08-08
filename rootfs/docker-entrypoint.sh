#!/usr/bin/env bashlib

readonly INOTIFY_EVENTS_DEFAULT='close_write,moved_to,create'
readonly INOTIFY_OPTIONS_DEFAULT=''

readonly DOMAIN_DEFAULT=''
readonly CERTNAME_DEFAULT='fullchain.pem'
readonly KEYNAME_DEFAULT='privkey.pem'
readonly KEYSTORE='/config/data/keystore'
readonly QUIET_PERIOD_DEFAULT=3600

readonly ROOT_CHAIN=$(cat <<-END
-----BEGIN CERTIFICATE-----
MIIDSjCCAjKgAwIBAgIQRK+wgNajJ7qJMDmGLvhAazANBgkqhkiG9w0BAQUFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTAwMDkzMDIxMTIxOVoXDTIxMDkzMDE0MDExNVow
PzEkMCIGA1UEChMbRGlnaXRhbCBTaWduYXR1cmUgVHJ1c3QgQ28uMRcwFQYDVQQD
Ew5EU1QgUm9vdCBDQSBYMzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AN+v6ZdQCINXtMxiZfaQguzH0yxrMMpb7NnDfcdAwRgUi+DoM3ZJKuM/IUmTrE4O
rz5Iy2Xu/NMhD2XSKtkyj4zl93ewEnu1lcCJo6m67XMuegwGMoOifooUMM0RoOEq
OLl5CjH9UL2AZd+3UWODyOKIYepLYYHsUmu5ouJLGiifSKOeDNoJjj4XLh7dIN9b
xiqKqy69cK3FCxolkHRyxXtqqzTWMIn/5WgTe1QLyNau7Fqckh49ZLOMxt+/yUFw
7BZy1SbsOFU5Q9D8/RhcQPGX69Wam40dutolucbY38EVAjqr2m7xPi71XAicPNaD
aeQQmxkqtilX4+U9m5/wAl0CAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAOBgNV
HQ8BAf8EBAMCAQYwHQYDVR0OBBYEFMSnsaR7LHH62+FLkHX/xBVghYkQMA0GCSqG
SIb3DQEBBQUAA4IBAQCjGiybFwBcqR7uKGY3Or+Dxz9LwwmglSBd49lZRNI+DT69
ikugdB/OEIKcdBodfpga3csTS7MgROSR6cz8faXbauX+5v3gTt23ADq1cEmv8uXr
AvHRAosZy5Q6XkjEGB5YGV8eAlrwDPGxrancWYaLbumR9YbK+rlmM6pZW87ipxZz
R8srzJmwN0jP41ZL9c8PDHIyh8bwRLtTcm1D9SZImlJnt1ir/md2cXjbDaJWFBM5
JDGFoqgCWjBH4d1QB7wCCZAA62RjYJsWvIjJEubSfZGL+T0yjWW06XyxV3bqxbYo
Ob8VZRzI9neWagqNdwvYkQsEjgfbKbYK7p2CNTUQ
-----END CERTIFICATE-----
END
)

declare INOTIFY_EVENTS=${INOTIFY_EVENTS:-${INOTIFY_EVENTS_DEFAULT}}
declare INOTIFY_OPTIONS=${INOTIFY_OPTIONS:-${INOTIFY_OPTIONS_DEFAULT}}

declare DOMAIN=${DOMAIN:-${DOMAIN_DEFAULT}}
declare CERTNAME=${CERTNAME:-${CERTNAME_DEFAULT}}
declare KEYNAME=${KEYNAME:-${KEYNAME_DEFAULT}}

declare QUIET_PERIOD=${QUIET_PERIOD:-${QUIET_PERIOD_DEFAULT}}

declare WATCHDIR

function start() {
  ::log.trace "${FUNCNAME[0]}:" "$@"

  get_watches

  ::log.debug "Using events: ${INOTIFY_EVENTS}"
  ::log.debug "Using options: ${INOTIFY_OPTIONS}"
  ::log.debug "Watching directory: ${WATCHDIR}"``

  init_certs "${WATCHDIR}"

  ::log.info 'Starting inotifywait'
  inotifywait -q -m -e ${INOTIFY_EVENTS} ${INOTIFY_OPTIONS} "${WATCHDIR}" | \
      while read -r path event file;
      do
        ::log.debug "File: ${file}; Path: ${path}; Event: ${event}"
        update_cert "${WATCHDIR}"
      done
  return "${__BASHLIB_EXIT_OK}"
}

function init_certs() {
  local path=${1}
  local certfile="${path}/${CERTNAME}"
  local keyfile="${path}/${KEYNAME}"

  if ::fs.file_exists "${certfile}" && ::fs.file_exists "${keyfile}"; then
    ::log.info 'Initializing Certificate'
    update_cert "${path}"
  fi
}

function get_watches() {
  ::log.trace "${FUNCNAME[0]}:" "$@"

  local -a watches

  mapfile -t watches < <(find /certificates -type d -name "${DOMAIN}")
  ::log.trace "Watch directories found: ${watches[@]}"
  if (( ${#watches[@]})); then
    WATCHDIR=("${watches[0]}")
  fi
}

function init_keystore() {
  ::log.trace "${FUNCNAME[0]}:" "$@"

  ::log.info 'Intializing keystore...'
    keytool \
      -genkey \
      -keyalg RSA \
      -alias unifi \
      -keystore "${KEYSTORE}" \
      -storepass aircontrolenterprise \
      -keypass aircontrolenterprise \
      -validity 1825 \
      -keysize 4096 \
      -dname "cn=UniFi" || \
      ::exit.nok "Failed creating UniFi keystore"

    keytool \
      -importkeystore \
      -srckeystore "${KEYSTORE}" \
      -srcstorepass aircontrolenterprise \
      -destkeystore "${KEYSTORE}" \
      -deststorepass aircontrolenterprise \
      -deststoretype pkcs12 || \
      ::exit.nok "Failed to convert UniFi keystore to PKCS12"
}

function update_cert() {
  ::log.trace "${FUNCNAME[0]}:" "$@"
  local path=${1}
  local certfile="${path}/${CERTNAME}"
  local keyfile="${path}/${KEYNAME}"
  local newKeystore=false

  if ! ::fs.file_exists "${KEYSTORE}"; then
    init_keystore;
    newKeystore=true
  fi

  if ::var.true ${newKeystore} || ! _recent_update ${certfile}; then
    ::log.info "Updating certificate in keystore using ${certfile}"

    tempcert=$(mktemp)
    temppkcs=$(mktemp)

    # Adds Identrust cross-signed CA cert in case of letsencrypt
    if [[ $(openssl x509 -noout -ocsp_uri -in "${certfile}") == *"letsencrypt"* ]]; then
        echo "${ROOT_CHAIN}" > "${tempcert}"
        cat "${certfile}" >> "${tempcert}"
    else
        cat "${certfile}" > "${tempcert}"
    fi
    
    ::log.debug 'Preparing certificate in a format UniFi accepts...'
    openssl pkcs12 \
        -export  \
        -passout pass:aircontrolenterprise \
        -in "${tempcert}" \
        -inkey "${keyfile}" \
        -out "${temppkcs}" \
        -name unifi

    ::log.debug 'Removing existing certificate from UniFi protected keystore...'
    keytool \
        -delete \
        -alias unifi \
        -keystore "${KEYSTORE}" \
        -deststorepass aircontrolenterprise

    ::log.debug 'Inserting certificate into UniFi keystore...'
    keytool \
        -trustcacerts \
        -importkeystore \
        -deststorepass aircontrolenterprise \
        -destkeypass aircontrolenterprise \
        -destkeystore "${KEYSTORE}" \
        -srckeystore "${temppkcs}" \
        -srcstoretype PKCS12 \
        -srcstorepass aircontrolenterprise \
        -alias unifi

    # Cleanup
    rm -f "${tempcert}"
    rm -f "${temppkcs}"
  fi
}

function _recent_update() {
  ::log.trace "${FUNCNAME[0]}:" "$@"
  local lastupdatetime=$(($(stat -c '%Y' "${KEYSTORE}")+${QUIET_PERIOD}))
  local certtime=$(stat -c '%Y' "${1}")

  if ::var.greater_than "${lastupdatetime}" "${certtime}"; then
    return "${__BASHLIB_EXIT_OK}"
  fi

  return "${__BASHLIB_EXIT_NOK}"
}

function usage() {
  ::log.trace "${FUNCNAME[0]}:" "$@"

  local message=(
    ""
    "docker run -v CERTIFICATES_VOLUME:/certificates -v UNIFI_CONFIG_VOLUME:/config unifi_certs:TAG [OPTIONS]"
    ""
    "Options:"
    "	-h|--help			show this help"
    "	-d|--domain DOMAIN		specifies the domain directory that contains cert files"
    "	-c|--certname CERTNAME		name of the certificate file"
    "						[Default: '${CERTNAME_DEFAULT}']"
    "	-k|--keyname KEYNAME		name of private key file"
    "						[Default: '${KEYNAME_DEFAULT}']"
    "	-e|--events INOTIFY_EVENTS	inotify events to act on"
    "						[Default: '${INOTIFY_EVENTS_DEFAULT}']"
    "	-o|--options INOTIFY_OPTIONS	options for inotify"
    "						[Default: '${INOTIFY_OPTIONS_DEFAULT}']"
  )
  printf '%s\n' "${message[@]}"
  return "${__BASHLIB_EXIT_OK}"
}

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -e|--events)
      INOTIFY_EVENTS=$2
      shift 2
      ;;
    -o|--options)
      INOTIFY_OPTIONS=$2
      shift 2
      ;;
    -d|--domain)
      DOMAIN=$2
      shift 2
      ;;
    -c|--certname)
      CERTNAME=$2
      shift 2
      ;;
    -k|--keyname)
      KEYNAME=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit "${__BASHLIB_EXIT_OK}"
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit "${__BASHLIB_EXIT_NOK}"
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

start