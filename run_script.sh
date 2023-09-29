#!/usr/bin/env bash

#---------------------- Global Variables ----------------------
TEST_ARTIFACT_DIR="results"


#------------------------- Functions --------------------------
arg_handle() {
    CLI_ARGS=$@
    ARGS_LIST=":a:u:p:h"
    while getopts $ARGS_LIST opt; do
        case "$opt" in
            a) 
                export TRUST_APP_URL="$OPTARG"
                ;;
            u)
                export TRUST_USERNAME="$OPTARG"
                ;;
            p)
                export TRUST_PASSWORD="$OPTARG"
                ;;
            h)
                help $OPTARG
                exit 0
                ;;
            :)
                echo "Option $OPTARG requires an option" >&2
                exit 1
                ;;
            \?)
                echo "Invalid option: $OPTARG" >&2
                help $OPTARG
                exit 1
                ;;
           
        esac
    done     
}

shift $((OPTIND - 1))

set_venv(){

    VENV_ROOT="${PWD}/venv"
    cmd="${VENV_ROOT}/bin/playwright --version"

    if  (! $cmd &> /dev/null); then
        echo "----- Creating python virtual environment for Playwright -----"
        python3 -m venv ${VENV_ROOT}
        source ${VENV_ROOT}/bin/activate
        "${VENV_ROOT}"/bin/pip3 install -r requirements.txt
    fi

}

create_artifact_dir(){
    mkdir -p "${TEST_ARTIFACT_DIR}/testrun-$(date +%Y-%m-%d-%H-%M)"
}

help(){
    echo "--------------------------------------------------------------"
    echo "Tool to execute Trustification Guardian scripts"
    echo "For Further information please visit https://github.com/mrrajan/trust_guardians.git"
    echo "Usage run_script.h [commands]"
    echo "Available Commands:"
    echo "     -a    Application URL to test"
    echo "     -u    Registered Username"
    echo "     -p    Valid Password for the user"
    echo "     -h    help for run_script.sh"
    echo "--------------------------------------------------------------"
}

if [ "$#" -eq 0 ]; then
    help
    exit 1
fi

arg_handle "$@"

echo "-------------------------- STARTING --------------------------"
set_venv
create_artifact_dir

set +e
pytest -V
set -e

echo "---------------------------- END -----------------------------"