#!/usr/bin/env bash
set -euo pipefail

NS="${1:-odi}"

# Remove finalizers from *all* namespaced resources in the namespace
for r in $(kubectl api-resources --namespaced -o name | tr -d '\r'); do
  kubectl -n "$NS" get "$r" -o name 2>/dev/null \
  | xargs -r -n1 kubectl -n "$NS" patch --type=merge -p '{"metadata":{"finalizers":[]}}' || true
done

# Best-effort: kick the namespace finalizers (works even if jq isn't present)
kubectl get ns "$NS" -o json \
| sed 's/"finalizers":[[:space:]]*\[[^]]*\]//' \
| kubectl replace --raw "/api/v1/namespaces/$NS/finalize" -f - >/dev/null 2>&1 || true