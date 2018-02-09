set -eo pipefail

[[ "$TRACE" ]] && set -x

export TILLER_NAMESPACE="$KUBE_NAMESPACE"

create_kubeconfig() {
  [[ -z "$KUBE_URL" ]] && return

  echo "Generating kubeconfig..."
  export KUBECONFIG="$(pwd)/kubeconfig"
  export KUBE_CLUSTER_OPTIONS=
  if [[ -n "$KUBE_CA_PEM" ]]; then
    echo "Using KUBE_CA_PEM..."
    echo "$KUBE_CA_PEM" > "$(pwd)/kube.ca.pem"
    export KUBE_CLUSTER_OPTIONS=--certificate-authority="$(pwd)/kube.ca.pem"
  fi
  kubectl config set-cluster gitlab-deploy --server="$KUBE_URL" \
    $KUBE_CLUSTER_OPTIONS
  kubectl config set-credentials gitlab-deploy --token="$KUBE_TOKEN" \
    $KUBE_CLUSTER_OPTIONS
  kubectl config set-context gitlab-deploy \
    --cluster=gitlab-deploy --user=gitlab-deploy \
    --namespace="$KUBE_NAMESPACE"
  kubectl config use-context gitlab-deploy
  echo ""
}


ensure_deploy_variables() {
  if [[ -z "$KUBE_NAMESPACE" ]]; then
    echo "Missing KUBE_NAMESPACE."
    exit 1
  fi

}

ping_kube() {
  if kubectl version > /dev/null; then
    echo "Kubernetes is online!"
    echo ""
  else
    echo "Cannot connect to Kubernetes."
    return 1
  fi
}

ensure_namespace() {
  cat <<EOF | kubectl apply -f -
kind: Namespace
apiVersion: v1
metadata:
  name: $KUBE_NAMESPACE
EOF
}

install_tiller() {
  echo "Checking Tiller..."
  if ! helm version &>/dev/null; then
    echo "Configuring Tiller..."
    helm init
    kubectl rollout status -n "$TILLER_NAMESPACE" -w "deployment/tiller-deploy"
    if ! helm version --debug; then
      echo "Failed to init Tiller."
      return 1
    fi
  fi
  echo ""
}
