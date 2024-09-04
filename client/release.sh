#!/usr/bin/env bash
#-*- coding: utf-8 -*-

# parameters
scheme=OrzMC
team_id=2N62934Y28
configuration=Release
destination="generic/platform=macOS"

apple_id="824219521@qq.com"
app_specific_password="bbgb-nzuk-trqz-uzax"
notary_timeout_duration="5m"

# path defination
git_repo_dir=$(git rev-parse --show-toplevel)
derived_data_path="$git_repo_dir/DerivedData"
build_dir=$git_repo_dir/build
archive_path="$build_dir/$scheme.xcarchive"
client_dir=$git_repo_dir/client

export_options_plist=$client_dir/exportOptions.plist
export_path=$client_dir
export_app=$export_path/$scheme.app
export_app_zip=$export_app.zip

# change work dir
cd $client_dir

# delete all zip files
zips=*.zip
for zip in $zips
do
    if [ -f $zip ]; then
        rm -f $zip
    fi
done

# archive 
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
xcrun xcodebuild archive                \
    -quiet                              \
    -scheme $scheme                     \
    -configuration $configuration       \
    -destination "$destination"         \
    -derivedDataPath $derived_data_path \
    -archivePath $archive_path
    

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

# export
xcrun xcodebuild                                \
	-exportArchive                              \
	-archivePath $archive_path                  \
	-exportOptionsPlist $export_options_plist   \
	-exportPath $export_path

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

# notary
xcrun notarytool submit                         \
    --apple-id $apple_id                        \
    --password $app_specific_password           \
    --team-id $team_id                          \
    --wait                                      \
    --timeout $notary_timeout_duration          \
    $export_app_zip

if [ $? -ne 0 ]; then
    echo notary failed!
    exit -5
fi

# staple 
xcrun stapler staple $export_app
if [ $? -ne 0 ]; then
    echo staple ticket failed!
    exit -6
fi

# Gatekeeper validity
spctl -a -t exec -vv $export_app
if [ $? -ne 0 ]; then
    echo gatekeeper validity failed!
    exit -7
fi

# delete export app zip file
if [ -f $export_app_zip ]; then
    rm -f $export_app_zip
fi

plistBuddyBin=/usr/libexec/PlistBuddy
app_info_plist="$export_app/Contents/Info.plist"

# sparkle
sparkle_SUPublicEDKey=$($plistBuddyBin -c "Print SUPublicEDKey" "$app_info_plist")
sparkle_bin=$derived_data_path/SourcePackages/artifacts/sparkle/Sparkle/bin
sparkle_generate_keys=$sparkle_bin/generate_keys
sparkle_generate_appcast=$sparkle_bin/generate_appcast

sparkle_generate_public_key=$($sparkle_generate_keys | grep -o "<string>.*</string>")
sparkle_generate_public_key=${sparkle_generate_public_key##<string>}
sparkle_generate_public_key=${sparkle_generate_public_key%%</string>}
sparkle_generate_private_key=sparkle_private_key

# update SUPublicEDKey if changed
if [ "$sparkle_SUPublicEDKey" != "$sparkle_generate_public_key" ]; then
    echo old: $sparkle_SUPublicEDKey
    echo new: $sparkle_generate_public_key
    # update SUPublicEDKey value
    $plistBuddyBin -c "Set :SUPublicEDKey $sparkle_generate_public_key" "$app_info_plist"
    # save private key into local keychain
    if [ -f $sparkle_generate_private_key ]; then
        rm -f $sparkle_generate_private_key
    fi
    $sparkle_generate_keys -x $sparkle_generate_private_key
    $sparkle_generate_keys -f $sparkle_generate_private_key
fi

# recreate zip for distribution
version=$($plistBuddyBin -c "Print CFBundleVersion" "$app_info_plist")
short_version=$($plistBuddyBin -c "Print CFBundleShortVersionString" "$app_info_plist")
date=$(date +%Y%m%d_%H%M%S)
product_dir=$git_repo_dir/products

# delete all tar.xz files
app_dist_file_ext="zip" # "tar.xz"
app_dist_files=$product_dir/*.${app_dist_file_ext}
for app_dist_file in $app_dist_files
do
    if [ -f $app_dist_file ]; then
        rm -f $app_dist_file
    fi
done

app_dist_file="${product_dir}/${scheme}_${short_version}_${version}_${date}.${app_dist_file_ext}"
case $app_dist_file_ext in
    "tar.xz")
        tar -C $export_path -cJf $app_dist_file $(basename $export_app)
        ;;
    "zip")
        ditto -c -k --sequesterRsrc --keepParent $export_app $app_dist_file
        ;;
    *):
        echo unsupportted file type
        ;;
esac

if [ $? -ne 0 ]; then
    echo create dist file with staple ticket failed!
    exit -8
fi

echo dist file of app: $app_dist_file

# generate appcast.xml
$sparkle_generate_appcast $product_dir

# change url
app_dist_file_name=$(basename $app_dist_file)
git_url=$(git remote get-url origin)
url_pattern="https://.*${app_dist_file_name//./\\.}"
target_url=${git_url%%.git}/releases/download/${short_version}/${app_dist_file_name}
target_url=${target_url//./\\.}
# echo pattern: $url_pattern
# echo target: $target_url
sed -i'' -e  "s|${url_pattern}|${target_url}|" $product_dir/appcast.xml

# clean up
if [ -d $build_dir ]; then
    rm -rf $build_dir
fi

if [ -d $derived_data_path ]; then
    rm -rf $derived_data_path
fi 

if [ -d $export_app ]; then
    rm -rf $export_app
fi

rm -f *.plist *.log
