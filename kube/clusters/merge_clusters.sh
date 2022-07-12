#!/usr/bin/env bash
CONFIGS=""
FILES="./*"
SEPARATOR=":"
for f in $FILES
do
	if [ $f != "./merge_clusters.sh" ]
	then
		echo $f
		CONFIGS=$CONFIGS$SEPARATOR$f
	fi
done
echo $CONFIGS
KUBECONFIG=$CONFIGS kubectl config view \
    --merge --flatten > ../config
