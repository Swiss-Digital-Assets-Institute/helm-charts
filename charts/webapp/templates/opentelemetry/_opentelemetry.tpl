{{/*
Return the appropriate annotations for instrumentation based on the language 
*/}}
{{- define "instrumentation-annotations" }}
{{- $annotations := dict }}
{{- if .Values.instrumentation.enabled }}
  {{- $language := .Values.instrumentation.language }}
  {{- $serviceName := .Values.name }}
  {{- $serviceNamespace := include "namespace" . }}
  {{- $serviceVersion := .Values.image.tag }}
  {{- $serviceEnv := .Values.global.env }}
  {{- $annotations = merge $annotations (dict 
    (printf "instrumentation.opentelemetry.io/inject-%s" $language) $serviceName
    "resource.opentelemetry.io/service.name" $serviceName
    "resource.opentelemetry.io/service.namespace" $serviceNamespace
    "resource.opentelemetry.io/service.version" $serviceVersion
    "resource.opentelemetry.io/deployment.environment.name" $serviceEnv
  ) }}
  {{- if eq $language "go" }}
    {{- $annotations = merge $annotations (dict 
      "instrumentation.opentelemetry.io/otel-go-auto-target-exe" (quote "/app")
      "sidecar.opentelemetry.io/inject" "sidecar"
    ) }}
  {{- end }}
{{- end }}
{{- $annotations | toYaml }}
{{- end }}
