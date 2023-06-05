{{/*
Expand the name of the chart.
*/}}
{{- define "hue.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hue.app.name" -}}
{{- template "hue.name" . -}}-app
{{- end -}}

{{/*
Create chart name and version as used by the subchart label.
*/}}
{{- define "hue.subchart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hue.fullname" -}}
{{- printf "%s-%s" .Release.Name "hue" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hue.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hue.labels" -}}
helm.sh/chart: {{ include "hue.chart" . }}
{{ include "hue.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hue.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hue.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hue.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hue.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "hue.config.fullname" -}}
{{- $fullname := include "hue.fullname" . -}}
{{- if contains "config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for a hue Secret containing Kerberos keytabs.
*/}}
{{- define "hue-keytabs-secret" -}}
{{- if .Values.global.kerberosKeytabsSecretOverride -}}
{{- .Values.global.kerberosKeytabsSecretOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "hue.fullname" . -}}
{{- printf "%s-keytabs" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "hue.svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}

{{/*
Construct the full name of hue service.
*/}}
{{- define "hue.hue-svc" -}}
{{- $pod := include "hue.fullname" . -}}
{{- $domain := include "hue.svc-domain" . -}}
{{- printf "%s.%s" $pod $domain -}}
{{- end -}}

{{/*
Construct the name of hue pod 0.
*/}}
{{- define "hue.hue-pod-0" -}}
{{- template "hue.fullname" . -}}-0
{{- end -}}

{{/*
Construct the full name of hue statefulset member 0.
*/}}
{{- define "hue.hue-svc-0" -}}
{{- $pod := include "hue.hue-pod-0" . -}}
{{- $service := include "hue.fullname" . -}}
{{- $domain := include "hue.svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}


{{/*
password postgres secret name
*/}}
{{- define "hue.secret.password.name" -}}
{{- printf "%s" "postgres-password-secret" -}}
{{- end -}}

{{/*
password postgres
*/}}
{{- define "hue.secret.password.key" -}}
{{- printf "%s" "postgres-password" -}}
{{- end -}}