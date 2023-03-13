#! /bin/bash
{{- $hdfs := template "hdfs-principal" . -}}
{{- $hive := template "hive-principal" . -}}
{{- $spark := template "spark-principal" . -}}
{{- $http := template "http-principal" . -}}
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q {{ printf "addprinc -randkey%s" $hdfs | quote}}
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q {{ printf "addprinc -randkey%s" $hive | quote}}
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q {{ printf "addprinc -randkey%s" $spark | quote}}
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q {{ printf "addprinc -randkey%s" $http | quote}}