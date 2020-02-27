#!/bin/sh

# script/bootstrap:
#	Resolve all dependencies that the application
#	requires to run.

set -e

cd "$(dirname "$0")/.."
SCRIPTS_DIR="$( cd "$( dirname "$0" )" && pwd )"

if [ -f ".gitmodules" ]; then
	printf "==> Cloning Git submodules: "
	git submodule foreach --recursive git fetch --all --prune || (echo "Fail" && exit 1)
	git submodule init || (echo "Fail" && exit 1)
	git submodule update || (echo "Fail" && exit 1)
	git submodule foreach --recursive git submodule init || (echo "Fail" && exit 1)
	git submodule foreach --recursive git submodule update || (echo "Fail" && exit 1)
	echo "Done"
fi

if [ -d "scripts/patches" ]; then
	printf "==> Applying QDeviceWatcher patch: "
	cd "src/qdevicewatcher"
	git apply "$SCRIPTS_DIR/patches/qdevicewatcher-prints.patch" || (echo "Patching failed")
	echo "Done"
fi	