{{- define "all-pod-annotations" }}
{{- $all := dict }}
{{- $pod := .Values.podAnnotations }}
{{- $all | toYaml }}
{{- end -}}

{{- /*
Merge deployment annotations with autoReloader functionality.
*/ -}}
{{- define "all-deploy-annotations" -}}
{{- $defaultAnnotations := dict "reloader.stakater.com/auto" "true" -}}
{{- $autoReloader := .Values.autoReloader | default false -}}
{{- $deploymentAnnotations := .Values.deployment.annotations | default dict -}}
{{- if $autoReloader -}}
  {{- $deploymentAnnotations = merge $deploymentAnnotations $defaultAnnotations -}}
{{- end -}}
{{- toYaml $deploymentAnnotations -}}
{{- end -}}
