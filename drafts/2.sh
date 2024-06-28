parameter1=$1
    if [ -z $1 ]; then
        exit 0
    fi
    for ((i=1;i<=$#;i++)); do
        if [[ `eval echo '$parameter'$i` = "--help" ]]; then
            echo "usage: ..."
            break
        fi
    done