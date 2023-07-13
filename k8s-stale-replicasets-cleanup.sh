#!/usr/bin/env bash

set -euo pipefail

echo "What do you want to delete?"
echo "1. All namespaces"
echo "2. Specific namespace"
read choice

case $choice in
  1)
    echo "Deleting all namespaces..."
    replicasets=$(kubectl get replicaset -A | awk '{ if ($4 == 0) { print $2 } }')
    echo "These replicasets will be deleted:"
    echo "${replicasets}"
    echo "Do you wish to continue with deletion? y/n"
    read response
    if [ "${response}" == "y" ]; then
      kubectl delete replicaset "${replicasets}"
    fi
  ;;
  2)
    echo "What keyspace should we query?"
    read namespace
    echo "These replicasets will be deleted:"
    replicasets=$(kubectl get replicaset -n "${namespace}" | awk '{ if ($4 == 0) { print $1 } }')
    echo "${replicasets}"
    echo "Do you wish to continue with deletion? y/n"
    read response
    if [ "${response}" == "y" ]; then
      kubectl delete replicaset -n "${namespace}" "${replicasets}"
    fi
  ;;
*)
    echo "Invalid choice."
    exit 1
esac
