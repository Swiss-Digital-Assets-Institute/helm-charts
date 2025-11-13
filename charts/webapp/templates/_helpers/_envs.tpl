{{- define "all-envs" -}}
{{- $envs := dict }}
{{- $secrets := dict }}
{{- $list := list }}
{{- $environments := .Values.envs }}
{{- range $_, $value := $environments }}
  {{- if $value.value }}
    {{- $_ = set $envs $value.name ($value.value | toString) }}
  {{- else }}
    {{- $_ = set $secrets $value.name $value.valueFrom }}
  {{- end }}
{{- end }}

{{- range $key, $value := $envs }}
  {{- $list = append $list (dict "name" $key "value" $value) }}
{{- end }}
{{- range $key, $value := $secrets }}
  {{- $list = append $list (dict "name" $key "valueFrom" $value )}}
{{- end }}

{{- if .Values.monitoring.tracing.enabled }}
  {{- $otelServiceName := .Values.monitoring.tracing.serviceName | default .Release.Namespace }}
  {{- $metricsAppName := .Values.monitoring.tracing.metricsAppName | default .Release.Name }}
  {{- $exporterEndpoint := .Values.monitoring.tracing.exporterEndpoint | default "http://alloy.observability.svc.cluster.local:4318/v1/traces" }}
  {{- $metricsPort := .Values.monitoring.tracing.metricsPort | default 9090 }}
  {{- $list = append $list (dict "name" "OTEL_SERVICE_NAME" "value" $otelServiceName) }}
  {{- $list = append $list (dict "name" "OTEL_EXPORTER_OTLP_ENDPOINT" "value" $exporterEndpoint) }}
  {{- $list = append $list (dict "name" "METRICS_PORT" "value" (toString $metricsPort)) }}
  {{- $list = append $list (dict "name" "METRICS_APP_NAME" "value" $metricsAppName) }}
{{- end }}

{{- toYaml $list }}
{{- end }}

{{- define "merged-envs" -}}
{{- $tmp := dict }}
{{- $secrets := dict }}
{{- $list := list }}
{{- range $_, $value := .envs }}
  {{- if $value.value }}
    {{- $_ = set $tmp $value.name ($value.value | toString) }}
  {{- else }}
    {{- $_ = set $secrets $value.name $value.valueFrom }}
  {{- end }}
{{- end }}
{{- range $_, $value := .overrides }}
  {{- if $value.value }}
    {{- $_ = set $tmp $value.name ($value.value | toString) }}
  {{- else }}
    {{- $_ = set $secrets $value.name $value.valueFrom }}
  {{- end }}
{{- end }}
{{- range $key, $value := $tmp }}
  {{- $list = append $list (dict "name" $key "value" $value) }}
{{- end }}
{{- range $key, $value := $secrets }}
  {{- $list = append $list (dict "name" $key "valueFrom" $value )}}
{{- end }}

{{- if and .tracing .tracing.enabled }}
  {{- $list = append $list (dict "name" "OTEL_SERVICE_NAME" "value" (.tracing.serviceName | default .releaseNamespace)) }}
  {{- $list = append $list (dict "name" "OTEL_EXPORTER_OTLP_ENDPOINT" "value" (.tracing.exporterEndpoint | default "http://alloy.observability.svc.cluster.local:4318/v1/traces")) }}
  {{- $list = append $list (dict "name" "METRICS_PORT" "value" (toString (.tracing.metricsPort | default 9090))) }}
  {{- $list = append $list (dict "name" "METRICS_APP_NAME" "value" (.tracing.metricsAppName | default .releaseName)) }}
{{- end }}

{{- toYaml $list }}
{{- end }}

{{/*
Helper to merge .Values.envFrom with externalSecret if enabled.
*/}}
{{- define "all-EnvFrom" -}}
{{- $envFrom := .Values.envFrom | default list -}}
{{- if .Values.externalSecrets.enabled -}}
  {{- $secretRef := dict "secretRef" (dict "name" (printf "kvv-%s" .Values.name)) -}}
  {{- $merged := append $envFrom $secretRef -}}
  {{- toYaml $merged -}}
{{- else -}}
  {{- toYaml $envFrom -}}
{{- end -}}
{{- end }}
