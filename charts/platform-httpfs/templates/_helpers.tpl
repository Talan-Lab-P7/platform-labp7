{{/*
Expand the name of the chart.
*/}}
{{- define "httpfs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "httpfs.app.name" -}}
{{- template "httpfs.name" . -}}-app
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "httpfs.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "httpfs.fullname" -}}
{{- printf "%s-%s" .Release.Name "httpfs" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "httpfs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "httpfs.labels" -}}
helm.sh/chart: {{ include "httpfs.chart" . }}
{{ include "httpfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "httpfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "httpfs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "httpfs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "httpfs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "httpfs.config.fullname" -}}
{{- $fullname := include "httpfs.fullname" . -}}
{{- if contains "config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for a httpfs Secret containing Kerberos keytabs.
*/}}
{{- define "httpfs-keytabs-secret" -}}
{{- if .Values.global.kerberosKeytabsSecretOverride -}}
{{- .Values.global.kerberosKeytabsSecretOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "httpfs.fullname" . -}}
{{- printf "%s-keytabs" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "httpfs.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the full name of httpfs service.
*/}}
{{- define "httpfs.httpfs-svc" -}}
{{- $pod := include "httpfs.fullname" . -}}
{{- $domain := include "httpfs.svc-domain" . -}}
{{- printf "%s.%s" $pod $domain -}}
{{- end -}}

{{/*
Construct the name of httpfs pod 0.
*/}}
{{- define "httpfs.httpfs-pod-0" -}}
{{- template "httpfs.fullname" . -}}-0
{{- end -}}

{{/*
Construct the full name of httpfs statefulset member 0.
*/}}
{{- define "httpfs.httpfs-svc-0" -}}
{{- $pod := include "httpfs.httpfs-pod-0" . -}}
{{- $service := include "httpfs.fullname" . -}}
{{- $domain := include "httpfs.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}