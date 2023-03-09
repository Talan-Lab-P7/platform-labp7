{{/*
Expand the name of the chart.
*/}}
{{- define "hiveMetaStore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hiveMetaStore.app.name" -}}
{{- template "hiveMetaStore.name" . -}}-app
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "hiveMetaStore.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hiveMetaStore.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hiveMetaStore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hiveMetaStore.labels" -}}
helm.sh/chart: {{ include "hiveMetaStore.chart" . }}
{{ include "hiveMetaStore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hiveMetaStore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hiveMetaStore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hiveMetaStore.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hiveMetaStore.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "hiveMetaStore.config.fullname" -}}
{{- $fullname := include "hiveMetaStore.fullname" . -}}
{{- if contains "config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for a hive Secret containing Kerberos keytabs.
*/}}
{{- define "hive-keytabs-secret" -}}
{{- if .Values.global.kerberosKeytabsSecretOverride -}}
{{- .Values.global.kerberosKeytabsSecretOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "hiveMetaStore.fullname" . -}}
{{- printf "%s-keytabs" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "hiveMetaStore.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the name of the metastore pod 0.
*/}}
{{- define "hiveMetaStore.metastore-pod-0" -}}
{{- template "hiveMetaStore.fullname" . -}}-0
{{- end -}}

{{/*
Construct the full name of the hive meta store statefulset member 0.
*/}}
{{- define "hiveMetaStore.metastore-svc-0" -}}
{{- $pod := include "hiveMetaStore.metastore-pod-0" . -}}
{{- $service := include "hiveMetaStore.fullname" . -}}
{{- $domain := include "hiveMetaStore.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}
