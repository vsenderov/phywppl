#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    exit
fi

n=$(($2))
echo Getting JS sources from $1 for $n iterations
mkdir $1.trees

for file in $1/*; do
    for ((i = 1; i <= $n; i++)); do
	echo $file $i/$n
	node --stack_size=256 --max-old-space-size=128 $file tree.nwk 1.0 1.0 >> $file.trees
    done
    mv $file.trees $1.trees/
done
