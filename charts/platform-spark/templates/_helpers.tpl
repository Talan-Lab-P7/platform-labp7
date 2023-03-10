{{/*
Expand the name of the chart.
*/}}
{{- define "spark.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "spark.app.name" -}}
{{- template "spark.name" . -}}-app
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "spark.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "spark.fullname" -}}
{{- printf "%s-%s" .Release.Name "spark" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "spark.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "spark.labels" -}}
helm.sh/chart: {{ include "spark.chart" . }}
{{ include "spark.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "spark.selectorLabels" -}}
app.kubernetes.io/name: {{ include "spark.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "spark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "spark.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "spark.config.fullname" -}}
{{- $fullname := include "spark.fullname" . -}}
{{- if contains "config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for a spark Secret containing Kerberos keytabs.
*/}}
{{- define "spark-keytabs-secret" -}}
{{- if .Values.global.kerberosKeytabsSecretOverride -}}
{{- .Values.global.kerberosKeytabsSecretOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "spark.fullname" . -}}
{{- printf "%s-keytabs" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "spark.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the full name of spark service.
*/}}
{{- define "spark.spark-svc" -}}
{{- $pod := include "spark.fullname" . -}}
{{- $domain := include "spark.svc-domain" . -}}
{{- printf "%s.%s" $pod $domain -}}
{{- end -}}

{{/*
Construct the name of spark pod 0.
*/}}
{{- define "spark.spark-pod-0" -}}
{{- template "spark.fullname" . -}}-0
{{- end -}}

{{/*
Construct the full name of spark statefulset member 0.
*/}}
{{- define "spark.spark-svc-0" -}}
{{- $pod := include "spark.spark-pod-0" . -}}
{{- $service := include "spark.fullname" . -}}
{{- $domain := include "spark.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}