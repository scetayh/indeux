#!/bin/bash

function checkParameterExistence() {
    #echo "B: $1"
    #eval echo "C: '$parameter'$1"
    if [ -z $1 ]; then
        exit 1
    fi
    for ((i=1;i<=$#;i++)); do
        #echo "D: $1"
        if [[ `eval echo '$parameter'$i` = $1 ]]; then
            echo "usage: ..."
            break
        fi
    done
}

parameterNumber=$#

for ((i=1;i<=$parameterNumber;i++)); do
    eval export parameter$i='$'$i
    #echo "A: ${parameter1}"
done

checkParameterExistence --help