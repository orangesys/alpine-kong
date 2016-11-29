#!/bin/bash

set -e

dir=.
if [ $# -gt 0 ]; then
  dir=("$@")
fi

log_msg() {
  echo "[$(date "+%Y/%m/%d %H:%M:%S %z")] $@"
}

log_msg "Verifying docker daemon connectivity"

# Gather directories with a Dockerfile and sanitize the path to remove leading
# a leading ./ and multiple slashes into a single slash.
dockerfiles=$(find "$dir" -name Dockerfile -print0 | xargs -0 -I{} dirname {} | sed 's@^./@@' | sed 's@//*@/@g')
for path in $dockerfiles; do
  # Generate a tag by replacing the first slash with a colon and all remaining slashes with a dash.
  tag=$(echo $path | sed 's@/@:@' | sed 's@/@-@g')
  log_msg "Tagging docker image $tag with gcr tag"
  docker tag "orangesys/alpine-kong:${tag}" "asia.gcr.io/saas-orangesys-io/alpine-kong:${tag}"
  sudo /opt/google-cloud-sdk/bin/gcloud docker push asia.gcr.io/saas-orangesys-io/alpine-kong:${tag}
done
