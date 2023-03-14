#! /bin/bash
helm install platform-labp7 -n test  . --set tags.ha=false --set tags.simple=true --set tags.ranger=false --set global.namenodeHAEnabled=false --set hdfs-simple-namenode-k8s.nodeSelector.hdfs-namenode-selector=hdfs-namenode-0 --set global.kerberosEnabled=true
echo date +"waiting 10 seconds for kerberos pod creation -%a %b %e %H:%M:%S %Z %Y"
sleep 10
kubectl get cm secrets-batch -o=jsonpath='{.data.script}'  -n test > /tmp/secrets.sh
chmod u+x /tmp/secrets.sh
sh /tmp/secrets.sh
