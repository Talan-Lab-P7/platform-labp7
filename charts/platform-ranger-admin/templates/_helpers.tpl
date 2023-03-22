{{/*
Expand the name of the chart.
*/}}
{{- define "ranger-admin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ranger-admin.fullname" -}}
{{- printf "%s-%s" .Release.Name "ranger-admin" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ranger-admin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ranger-admin.labels" -}}
helm.sh/chart: {{ include "ranger-admin.chart" . }}
{{ include "ranger-admin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ranger-admin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ranger-admin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ranger-admin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ranger-admin.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Construct the name of the ranger policy pod 0.
*/}}
{{- define "ranger-admin.ranger-pod-0" -}}
{{- template "ranger-admin.fullname" . -}}-0
{{- end -}}

{{- define "ranger-admin.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the full name of the hive meta store statefulset member 0.
*/}}
{{- define "ranger-admin.ranger-svc-0" -}}
{{- $pod := include "ranger-admin.ranger-pod-0" . -}}
{{- $service := include "ranger-admin.fullname" . -}}
{{- $domain := include "ranger-admin.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}

{{- define "ranger-admin.config.install.properties" -}}
{{- $fullname := include "ranger-admin.fullname" . -}}
{{- if contains "install-config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-install-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "ranger-admin.config.kms.site" -}}
{{- $fullname := include "ranger-admin.fullname" . -}}
{{- if contains "kms-config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-kms-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "ranger-admin.client.name" -}}
{{- template "ranger-admin.name" . -}}-client
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "ranger-admin.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}