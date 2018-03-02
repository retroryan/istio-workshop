#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  >&2 echo Must supply an istio root directory
  exit 63
fi

root_dir=$1
book_info="$root_dir/samples/bookinfo/kube"
if command -v realpath >/dev/null 2>&1; then
  book_info=$(realpath "$book_info")
fi

read -p "Copying rbac samples to $book_info, continue? [Y/n] " confirm 
if [[ -z "$confirm" ]] || [[ "$confirm" =~ y|Y ]]; then
  echo "Copying..."
else
  echo "Aborting"
  exit 63
fi

files[0]="bookinfo-add-serviceaccount.yaml"
files[1]="istio-rbac-enable.yaml"
files[2]="istio-rbac-namespace.yaml"
files[3]="istio-rbac-productpage.yaml"
files[4]="istio-rbac-details-reviews.yaml"
files[5]="istio-rbac-ratings.yaml"

for f in ${files[*]}; do
  curl -L "https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/kube/$f" >"$book_info/$f"
done
