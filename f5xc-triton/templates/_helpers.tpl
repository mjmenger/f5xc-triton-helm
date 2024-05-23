{{/*
Expand the name of the chart.
*/}}
{{- define "f5xc-triton.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "f5xc-triton.fullname" -}}
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
{{- define "f5xc-triton.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "f5xc-triton.labels" -}}
helm.sh/chart: {{ include "f5xc-triton.chart" . }}
{{ include "f5xc-triton.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "f5xc-triton.selectorLabels" -}}
app.kubernetes.io/name: {{ include "f5xc-triton.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "f5xc-triton.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "f5xc-triton.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "f5xc-triton-grafana.name" -}}
{{ printf "%s-%s" .Chart.Name "grafana" | trunc 63 | trimSuffix "-" }} 
{{- end }}

{{- define "f5xc-triton-grafana.fullname" -}}
{{ printf "%s-%s-%s" .Chart.Name .Release.Name "grafana" | trunc 63 | trimSuffix "-" }} 
{{- end }}

{{/*
Common labels
*/}}
{{- define "f5xc-triton-grafana.labels" -}}
helm.sh/chart: {{ include "f5xc-triton.chart" . }}
{{ include "f5xc-triton-grafana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "f5xc-triton-grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "f5xc-triton-grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}