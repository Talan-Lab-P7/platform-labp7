#! /bin/bash
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q "addprinc -randkey " {{ template "hdfs-principal" . }} 
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q "addprinc -randkey " {{ template "hdfs-principal" . }}
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q "addprinc -randkey " {{ template "hdfs-principal" . }}
kubectl -n {{ .Release.Namespace }} exec {{ template "hdfs-k8s.krb5.fullname" . }} -- kadmin.local -q "addprinc -randkey " {{ template "hdfs-principal" . }}