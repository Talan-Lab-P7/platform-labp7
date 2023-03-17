#! /bin/bash
helm uninstall platform-labp7 -n test
kubectl delete pvc --all -n test
kubectl delete cm --all -n test
kubectl delete secrets --all -n test
rm /tmp/hive.keytab
rm /tmp/spark.keytab
rm /tmp/hdfs.keytab
rm /tmp/secrets.sh