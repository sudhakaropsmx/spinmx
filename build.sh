#!/usr/bin/env bash

set -e
set -x

VERSION=
RELEASE_PHASE=
go_os=
go_arch=


function process_args() {
  while [[ $# > 0 ]]
  do
    local key="$1"
    shift
    case $key in
      --go-arch)
        go_arch="$1"
        shift
        ;;
      --go-os)
        go_os="$1"
        echo $go_os
        shift
        ;;
      --release-phase)
        RELEASE_PHASE="$1"
        shift
        ;;
      --version)
        VERSION="$1"
        shift
        ;;
      --help|-help|-h)
        print_usage
        exit 0
        ;;
      *)
        echo "ERROR: Unknown argument '$key'"
        exit -1
    esac
  done
}


function print_usage() {
    cat <<EOF
usage: $0 --version <version>
      [--go-arch <arch>] [--go-os <os>]
      [--release-phase <phase>]


    --go-arch <arg>              Architecture to build the binary for.

    --go-os <arg>                OS distribution to build for binary for.

    --release-phase <arg>        Release phase to decorate the version with.

    --version <arg>              Version to build the `spin` binaries with.
EOF
}


process_args "$@"

if [ -z "$VERSION" ]; then
    echo "No Version specified, using git hash at head."
    VERSION=$(git rev-parse HEAD)
fi

if [ ! -z "$go_arch"]; then
    export $GOARCH=$go_arch
fi

if [ ! -z "$go_os"]; then
    export $GO_OS=$go_os
fi

#LD_FLAGS="-X github.com/opsmx/spinmx/version.Version=${VERSION} \
#-X github.com/spinnaker/opsmx/spinmx/version.ReleasePhase=${RELEASE_PHASE}"
#go clean
#go get -d -v
#CGO_ENABLED=0 go build -ldflags "${LD_FLAGS}"
CGO_ENABLED=0 go build 
