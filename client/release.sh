#!/usr/bin/env bash
#-*- coding: utf-8 -*-

scheme=OrzMC
configuration=Release
destination="generic/platform=macOS"
git_repo_dir=$(git rev-parse --show-toplevel)
derived_data_path="$git_repo_dir/DerivedData"
build_dir=$git_repo_dir/build
client_dir=$git_repo_dir/client
cd $client_dir
xcodebuild archive \
    -derivedDataPath $derived_data_path \
    -archivePath "$build_dir/$scheme" \
    -scheme $scheme \
    -configuration $configuration \
    -destination "$destination" # -dry-run