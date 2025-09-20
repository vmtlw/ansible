#!/bin/bash
# Удаляет все поды Kubernetes не в состоянии Running.
# Требует настроенный kubeconfig.
set -euo pipefail

kubectl get pods --all-namespaces \
  --field-selector=status.phase!=Running \
  -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name --no-headers |
while read -r namespace pod; do
  echo "Deleting pod $pod in namespace $namespace"
  kubectl delete pod "$pod" -n "$namespace"
done
