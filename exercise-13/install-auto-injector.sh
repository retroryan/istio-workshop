#!/usr/bin/env bash

set -euo pipefail

if [[ -z $1 ]]; then
  >&2 echo "No istio root directory provided"
  exit 63
fi

root_dir="$1"
install_dir="$root_dir/install/kubernetes"
if command -v realpath >/dev/null 2>&1; then
  root_dir=$(realpath "$root_dir")
  install_dir=$(realpath "$install_dir")
fi

read -p "Installing auto-injector from $root_dir, continue? [Y/n] " confirm
if [[ -z "$confirm" ]] || [[ "$confirm" =~ y|Y ]]; then
  echo "Proceeding.."
else
  echo "Aborting.."
  exit 63
fi

pushd "$root_dir" >/dev/null

base_uri="https://raw.githubusercontent.com/istio/istio/master/install/kubernetes"

scripts=("webhook-create-signed-cert.sh" "webhook-patch-ca-bundle.sh")

for script in ${scripts[*]}; do
  f="$install_dir/$script"
  curl -Ls "$base_uri/$script" >"$f" 2>/dev/null
  chmod +x "$f"
done

./install/kubernetes/webhook-create-signed-cert.sh \
    --service istio-sidecar-injector \
    --namespace istio-system \
    --secret sidecar-injector-certs

kubectl apply -f install/kubernetes/istio-sidecar-injector-configmap-release.yaml

cat install/kubernetes/istio-sidecar-injector.yaml | \
     ./install/kubernetes/webhook-patch-ca-bundle.sh > \
     install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml

kubectl apply -f install/kubernetes/istio-sidecar-injector-with-ca-bundle.yaml

popd >/dev/null

echo "Done."
