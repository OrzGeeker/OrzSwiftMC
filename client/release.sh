#!/usr/bin/env bash
#-*- coding: utf-8 -*-

scheme=OrzMC
team_id=2N62934Y28
configuration=Release
destination="generic/platform=macOS"
git_repo_dir=$(git rev-parse --show-toplevel)
derived_data_path="$git_repo_dir/DerivedData"
build_dir=$git_repo_dir/build
archive_path="$build_dir/$scheme.xcarchive"
client_dir=$git_repo_dir/client
export_options_plist=$client_dir/exportOptions.plist
export_path=$client_dir
export_app=$export_path/$scheme.app
export_app_zip=$export_app.zip

cd $client_dir

# Archive 
xcrun xcodebuild archive \
    -scheme $scheme \
    -configuration $configuration \
    -destination "$destination" \
    -derivedDataPath $derived_data_path \
    -archivePath $archive_path # -dry-run

if [ $? -ne 0 ]; then
    echo archive failed!
    exit -1
fi

# make export options plist file
cat > $export_options_plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>teamID</key>
        <string>${team_id}</string>
        <key>method</key>
        <string>developer-id</string>
    </dict>
</plist>
EOF

if [ $? -ne 0 ]; then
    echo create export plist failed!
    exit -2
fi

# Export
xcrun xcodebuild \
	-exportArchive \
	-archivePath $archive_path \
	-exportOptionsPlist $export_options_plist \
	-exportPath $export_path # -dry-run

if [ $? -ne 0 ]; then
    echo export failed!
    exit -3
fi

# create zip file
ditto -c -k --sequesterRsrc --keepParent $export_app $export_app_zip
if [ $? -ne 0 ]; then
    echo create zip failed!
    exit -4
fi

# Notary
apple_id="824219521@qq.com"
app_specific_password="bbgb-nzuk-trqz-uzax"
timeout_duration="1h"
xcrun notarytool submit               \
    --apple-id $apple_id              \
    --password $app_specific_password \
    --team-id $team_id                \
    --wait                            \
    --timeout $timeout_duration       \
    $export_app_zip

if [ $? -ne 0 ]; then
    echo notary failed!
    exit -5
fi

# Staple 
xcrun stapler staple $export_app
if [ $? -ne 0 ]; then
    echo staple ticket failed!
    exit -6
fi

# Recreate Zip for Distribution
if [ -f $export_app_zip ]; then
    rm -f $export_app_zip
fi
ditto -c -k --sequesterRsrc --keepParent $export_app $export_app_zip
if [ $? -ne 0 ]; then
    echo create zip with staple ticket failed!
    exit -7
fi

#