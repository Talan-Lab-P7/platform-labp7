#! /bin/bash
helm install platform-labp7 -n test  . --set tags.ha=false --set tags.ranger=true --set tags.ranger=false --set global.namenodeHAEnabled=false --set hdfs-simple-namenode-k8s.nodeSelector.hdfs-namenode-selector=hdfs-namenode-0 --set global.kerberosEnabled=true
kubectl get cm secrets-batch -o=jsonpath='{.data.script}'  -n test > /tmp/secrets.sh
chmod u+x /tmp/secrets.sh
while [ $(kubectl get po -n test | grep krb5 | awk '{print $2}') != "1/1" ]; do
    echo "waiting kerberos pod creation " $(date +'%Y-%m-%d # %H:%M:%S')
    sleep 5
done
sh /tmp/secrets.sh
