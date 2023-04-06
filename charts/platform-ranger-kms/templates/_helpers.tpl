{{/*
Expand the name of the chart.
*/}}
{{- define "ranger-kms.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ranger-kms.fullname" -}}
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
{{- define "ranger-kms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ranger-kms.labels" -}}
helm.sh/chart: {{ include "ranger-kms.chart" . }}
{{ include "ranger-kms.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ranger-kms.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ranger-kms.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ranger-kms.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ranger-kms.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "ranger-kms.config.install.properties" -}}
{{- $fullname := include "ranger-kms.fullname" . -}}
{{- if contains "install-config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-install-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Construct the name of the ranger kms pod 0.
*/}}
{{- define "ranger-kms.ranger-pod-0" -}}
{{- template "ranger-kms.fullname" . -}}-0
{{- end -}}

{{- define "ranger-kms.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the full name of the ranger kms statefulset member 0.
*/}}
{{- define "ranger-kms.ranger-svc-0" -}}
{{- $pod := include "ranger-kms.ranger-pod-0" . -}}
{{- $service := include "ranger-kms.fullname" . -}}
{{- $domain := include "ranger-kms.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}