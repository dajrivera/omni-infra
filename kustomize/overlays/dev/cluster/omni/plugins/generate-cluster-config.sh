#!/bin/bash

RESOURCE_LIST=$(cat) # read the `kind: ResourceList` from stdin
CONF_PATH=$(echo "$RESOURCE_LIST" | yq e '.functionConfig.spec.configPath' - )
OUTPUT_PATH=$(echo "$RESOURCE_LIST" | yq e '.functionConfig.spec.outputPath' - )

CONF_PATH_GIT="/${CONF_PATH}"
CONF_PATH="$(git rev-parse --show-toplevel)/${CONF_PATH}"
CONF_HASH=$(find "$CONF_PATH" -type f -print | git hash-object --stdin-paths | git hash-object --stdin)

#cp -r $CONF_PATH/* $OUTPUT_PATH

cat <<EOF
kind: ResourceList
items:
- kind: ConfigMap
  apiVersion: v1
  metadata:
    name: omni-cluster-config-hash
    namespace: omni-system
  data:
    clusterConfigPath: $CONF_PATH_GIT
    clusterConfigHash: $CONF_HASH
EOF