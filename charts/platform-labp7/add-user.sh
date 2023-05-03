#! /bin/sh

if [[ $# -ne 4  ]]; then echo "Nombre de parametre incorrecte"; exit 1; fi

namespace=$1
username=$2
password=$3
realm=$4

kubectl exec platform-labp7-hdfs-krb5-0 -n $namespace -- kadmin.local -q "addprinc $username@$realm -needchange -pw $password"