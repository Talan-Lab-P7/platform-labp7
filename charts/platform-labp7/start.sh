#! /bin/bash
helm install platform-labp7 -n test  . --set tags.ha=false --set tags.simple=true --set tags.ranger=false --set global.namenodeHAEnabled=false --set hdfs-simple-namenode-k8s.nodeSelector.hdfs-namenode-selector=hdfs-namenode-0 --set global.kerberosEnabled=true
sleep 5
kubectl get cm secrets-batch -o=jsonpath='{.data.script}'  -n test > /tmp/secrets.sh
chmod u+x /tmp/secrets.sh
