#! /bin/bash
helm uninstall platform-labp7 -n $1
kubectl delete pvc --all -n $1
kubectl delete cm --all -n $1
kubectl delete secrets --all -n $1
rm /tmp/hive.keytab
rm /tmp/spark.keytab
rm /tmp/hdfs.keytab
rm /tmp/secrets.sh