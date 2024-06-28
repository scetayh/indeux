#!/bin/bash

TMC_USAGE="$0: usage: $0 [input 1] [input 2] [output]"

function tmcPrintUsage {
	echo $TMC_USAGE
	exit $1
}

if [ -z $1 ]; then
	tmcPrintUsage 1
fi

if [ ! -f $1 ]; then
	echo "$0: $1: file not found"
	exit 1
fi

if [ -z $2 ]; then
        tmcPrintUsage 1
fi

if [ ! -f $1 ]; then
        echo "$0: $2: file not found"
        exit 1
fi

if [ -z $3 ]; then
        tmcPrintUsage 1
fi

mkdir -p $(dirname $3)

TMC_INPUT_1_LINES=$(cat $1 | wc -l)
echo "TMC_INPUT_1_LINES=$TMC_INPUT_1_LINES"
TMC_INPUT_2_LINES=$(cat $2 | wc -l)
echo "TMC_INPUT_2_LINES=$TMC_INPUT_2_LINES"

if [ $TMC_INPUT_1_LINES -lt $TMC_INPUT_2_LINES ]; then
	TMC_INPUT_LESS=$1
	TMC_INPUT_LESS_LINES=$TMC_INPUT_1_LINES
	TMC_INPUT_MORE=$2
	TMC_INPUT_MORE_LINES=$TMC_INPUT_2_LINES
else
        TMC_INPUT_LESS=$2
        TMC_INPUT_LESS_LINES=$TMC_INPUT_2_LINES
        TMC_INPUT_MORE=$1
        TMC_INPUT_MORE_LINES=$TMC_INPUT_1_LINES

fi

for ((i=1; i<=$TMC_INPUT_LESS_LINES; i++)); do
	echo i=${i}
	sed -n "${i}p" $1 >> $3
	sed -n "${i}p" $2 >> $3
done

for ((i=${TMC_INPUT_LESS_LINES}+1; i<=$TMC_INPUT_MORE_LINES; i++)); do
	echo i=${i}
	sed -n "${i}p" $TMC_INPUT_MORE >> $3
done