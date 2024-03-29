#! /bin/bash
if [[ $# -eq null  ]]; then echo "Merci d'introduire le nom du namespace"; exit 1; fi
helm uninstall platform-labp7 -n $1
kubectl delete pvc --all -n $1
kubectl delete cm --all -n $1
kubectl delete secrets --all -n $1
rm /tmp/hive.keytab
rm /tmp/spark.keytab
rm /tmp/hdfs.keytab
rm /tmp/hue.keytab
rm /tmp/secrets.sh