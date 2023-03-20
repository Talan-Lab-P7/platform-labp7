{{/*
Expand the name of the chart.
*/}}
{{- define "hive-meta-store.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hive-meta-store.app.name" -}}
{{- template "hive-meta-store.name" . -}}-app
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "hive-meta-store.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hive-meta-store.fullname" -}}
{{- printf "%s-%s" .Release.Name "hive-meta-store" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hive-meta-store.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hive-meta-store.labels" -}}
helm.sh/chart: {{ include "hive-meta-store.chart" . }}
{{ include "hive-meta-store.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hive-meta-store.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hive-meta-store.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hive-meta-store.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hive-meta-store.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "hive-meta-store.config.fullname" -}}
{{- $fullname := include "hive-meta-store.fullname" . -}}
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
{{- $name := include "hive-meta-store.fullname" . -}}
{{- printf "%s-keytabs" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "hive-meta-store.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the name of the metastore pod 0.
*/}}
{{- define "hive-meta-store.metastore-pod-0" -}}
{{- template "hive-meta-store.fullname" . -}}-0
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "hive-meta-store.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hive-meta-store.client.name" -}}
{{- template "hive-meta-store.name" . -}}-client
{{- end -}}


{{/*
Construct the full name of the hive meta store statefulset member 0.
*/}}
{{- define "hive-meta-store.metastore-svc-0" -}}
{{- $pod := include "hive-meta-store.metastore-pod-0" . -}}
{{- $service := include "hive-meta-store.fullname" . -}}
{{- $domain := include "hive-meta-store.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}
