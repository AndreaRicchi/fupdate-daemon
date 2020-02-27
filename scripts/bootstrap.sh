#!/bin/sh

# script/bootstrap:
#	Resolve all dependencies that the application
#	requires to run.

set -e

cd "$(dirname "$0")/.."
SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"

if [ -f ".gitmodules" ]; then
	echo "==> Cloning Git submodules: "
	git submodule foreach --recursive git fetch --all --prune || (echo "Fail" && exit 1)
	git submodule init || (echo "Fail" && exit 1)
	git submodule update || (echo "Fail" && exit 1)
	git submodule foreach --recursive git submodule init || (echo "Fail" && exit 1)
	git submodule foreach --recursive git submodule update || (echo "Fail" && exit 1)
	echo "Done"
fi
