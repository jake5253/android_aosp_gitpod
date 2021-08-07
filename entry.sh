#!/bin/bash
SUBMODULES=true;

display_help () {
    cat << EOF
Usage of "$0":
    -m|--manifest_url=      This is where the manifest will be sourced from
    -b|--branch=            Specify a branch, otherwise we get the current branch
    -d|--depth=             Specify depth. Usually we only want the top-most tip
    -n|--no-submodules      Do not download submodules associated with the manifest repo
EOF
}

while (( "$#" )); do
  case "$1" in
    -m|--manifest_url=) shift;
      MANIFEST_URL="$1";
      shift
      ;;
    -b|--branch=) shift;
      BRANCH="$1";
      shift
      ;;
    -d|--depth=) shift;
      DEPTH="$1";
      shift
      ;;
    -n|--no-submodules)
      SUBMODULES=false;
      shift
      ;;
    -h|--help)
      display_help;
      exit 0
      ;;
    *) # unsupported flags
      echo "Error: Unsupported flag $1" >&2;
      exit 1
      ;;
  esac
done

MANIFEST_URL=${MANIFEST_URL:-https://android.googlesource.com/platform/manifest}
DEPTH=${DEPTH:-1}

[[ $BRANCH == "" ]] && BRANCHFLAG="-b $BRANCH" || BRANCHFLAG="-c";
[[ $SUBMODULES ]] && SUBMODULESFLAG="--submodules" || SUBMODULESFLAG="";

fn_initsource () {
    repo init --depth=$DEPTH $BRANCHFLAG $SUBMODULESFLAG -u $MANIFEST_URL;
}

fn_downloadsorce () {
    repo sync -j$(nproc);
}

echo "Initializing repo";
fn_initsource || echo "ERROR!" >&2;

echo "Downloading source";
fn_downloadsorce || echo "ERROR!" >&2;

ccache -M 50G;
source build/envsetup.sh;