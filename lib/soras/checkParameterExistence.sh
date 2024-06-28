#!/bin/bash

function checkParameterExistence() {
    for ((i=1;i<=$#;i++)); do
        eval [ '${'"$i"'}' = "$1" ] && break
    done
}