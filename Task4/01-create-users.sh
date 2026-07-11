#!/usr/bin/env bash
set -euo pipefail

PROFILE="${MINIKUBE_PROFILE:-minikube}"
MINIKUBE_HOME="${MINIKUBE_HOME:-$HOME/.minikube}"
CA_CRT="$MINIKUBE_HOME/ca.crt"
CA_KEY="$MINIKUBE_HOME/ca.key"
CERT_DIR="${CERT_DIR:-${TMPDIR:-/tmp}/task4-users}"

if [[ ! -f "$CA_CRT" || ! -f "$CA_KEY" ]]; then
  echo "Minikube CA files not found in $MINIKUBE_HOME" >&2
  exit 1
fi

mkdir -p "$CERT_DIR"
minikube update-context -p "$PROFILE" >/dev/null
CLUSTER="$(kubectl config view --minify -o jsonpath='{.contexts[0].context.cluster}')"

create_user() {
  local user="$1"
  local group="$2"

  openssl genrsa -out "$CERT_DIR/$user.key" 2048
  MSYS2_ARG_CONV_EXCL="/CN=" openssl req -new -key "$CERT_DIR/$user.key" -out "$CERT_DIR/$user.csr" -subj "/CN=$user/O=$group"
  openssl x509 -req -in "$CERT_DIR/$user.csr" -CA "$CA_CRT" -CAkey "$CA_KEY" -CAcreateserial -out "$CERT_DIR/$user.crt" -days 365

  kubectl config set-credentials "$user" \
    --client-certificate="$CERT_DIR/$user.crt" \
    --client-key="$CERT_DIR/$user.key" \
    --embed-certs=true

  kubectl config set-context "$user@$PROFILE" \
    --cluster="$CLUSTER" \
    --user="$user" \
    --namespace=default
}

create_user "viewer" "viewer"
create_user "editor" "editor"
create_user "admin" "admin"

echo "Users and kubeconfig contexts created."