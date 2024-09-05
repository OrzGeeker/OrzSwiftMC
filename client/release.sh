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
git_url=$(git remote get-url origin)
derived_data_path="$git_repo_dir/DerivedData"
build_dir=$git_repo_dir/build
archive_path="$build_dir/$scheme.xcarchive"
client_dir=$git_repo_dir/client
product_dir=$client_dir/products

export_options_plist=$client_dir/exportOptions.plist
export_path=$client_dir
export_app=$export_path/$scheme.app
export_app_zip=$export_app.zip

plistBuddyBin=/usr/libexec/PlistBuddy
app_info_plist="$export_app/Contents/Info.plist"

sparkle_bin=$derived_data_path/SourcePackages/artifacts/sparkle/Sparkle/bin

function remove() {
    for path in $*
    do
        # remove dir if exist
        if [ -d $path ]; then
            rm -rf $path
            echo removed dir: $path
        fi

        # remove file if exist
        if [ -f $path ]; then
            rm -f $path
            echo removed file: $path
        fi
    done
}

function zip() {
    local source=$1
    local target=$2
    ditto -c -k --sequesterRsrc --keepParent $source $target
    if [ $? -ne 0 ]; then
        echo create zip failed!
        exit -1
    fi
}

function tarxz() {
    local source=$1
    local target=$2
    tar -C $export_path -cJf $target $source
    if [ $? -ne 0 ]; then
        echo create tar.xz failed!
        exit -1
    fi
}

function build() {
    cd $client_dir                       && \
    xcrun xcodebuild build                  \
        -skipPackagePluginValidation        \
        -skipMacroValidation                \
        -quiet                              \
        -scheme $scheme                     \
        -configuration $configuration       \
        -destination "$destination"         \
        -derivedDataPath $derived_data_path
}

function sparkle() {
    cd $client_dir
    local app_info_plist="$client_dir/$(xcrun xcodebuild -showBuildSettings | grep -e ".plist" | grep -e INFOPLIST_FILE | cut -d '=' -f 2 | xargs)"
    if [ ! -f $app_info_plist ]; then
        echo info.plist file not found
        exit -1
    fi

    sparkle_SUFeedURL=$($plistBuddyBin -c "Print SUFeedURL" "$app_info_plist")
    sparkle_appcast_xml_URL=${git_url%%.git}
    sparkle_appcast_xml_URL=${sparkle_appcast_xml_URL/github.com/raw.githubusercontent.com}
    sparkle_appcast_xml_URL=${sparkle_appcast_xml_URL}/main${product_dir##"${git_repo_dir}"}/appcast.xml
    if [ "$sparkle_SUFeedURL" != "$sparkle_appcast_xml_URL" ]; then
        $plistBuddyBin -c "Set :SUFeedURL $sparkle_appcast_xml_URL" "$app_info_plist"
        echo update appcast xml url: $sparkle_appcast_xml_URL
    fi

    sparkle_SUPublicEDKey=$($plistBuddyBin -c "Print SUPublicEDKey" "$app_info_plist")
    sparkle_generate_keys=$sparkle_bin/generate_keys

    sparkle_existed_public_key=$($sparkle_generate_keys -p)
    sparkle_local_public_key=$sparkle_existed_public_key
    if [ -z $sparkle_existed_public_key ]; then
        sparkle_generate_public_key=$($sparkle_generate_keys | grep -o "<string>.*</string>")
        sparkle_generate_public_key=${sparkle_generate_public_key##<string>}
        sparkle_generate_public_key=${sparkle_generate_public_key%%</string>}
        # save private key into local keychain
        sparkle_generate_private_key=sparkle_private_key
        if [ -f $sparkle_generate_private_key ]; then
            rm -f $sparkle_generate_private_key
        fi
        $sparkle_generate_keys -x $sparkle_generate_private_key
        $sparkle_generate_keys -f $sparkle_generate_private_key
        # record new generated public key
        sparkle_local_public_key=$sparkle_generate_public_key
    fi

    # update SUPublicEDKey if changed
    if [ "$sparkle_SUPublicEDKey" != "$sparkle_local_public_key" ]; then
        echo old: $sparkle_SUPublicEDKey
        echo new: $sparkle_local_public_key
        # update SUPublicEDKey value with generated new public key
        $plistBuddyBin -c "Set :SUPublicEDKey $sparkle_local_public_key" "$app_info_plist"
    fi
}

function archive() {
    cd $client_dir                       && \
    xcrun xcodebuild archive                \
        -skipPackagePluginValidation        \
        -skipMacroValidation                \
        -quiet                              \
        -scheme $scheme                     \
        -configuration $configuration       \
        -destination "$destination"         \
        -derivedDataPath $derived_data_path \
        -archivePath $archive_path
}

function write_export_options_plist() {
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
}

function export() {
    xcrun xcodebuild                                \
        -exportArchive                              \
        -archivePath $archive_path                  \
        -exportOptionsPlist $export_options_plist   \
        -exportPath $export_path
}

function notarize() {
    zip $export_app $export_app_zip              && \
    xcrun notarytool submit                         \
        --apple-id $apple_id                        \
        --password $app_specific_password           \
        --team-id $team_id                          \
        --wait                                      \
        --timeout $notary_timeout_duration          \
        $export_app_zip                          && \
    xcrun stapler staple $export_app             && \
    spctl -a -t exec -vv $export_app             && \
    remove $export_app_zip
}

function distribute() {
    app_dist_file_ext=$1

    version=$($plistBuddyBin -c "Print CFBundleVersion" "$app_info_plist")
    short_version=$($plistBuddyBin -c "Print CFBundleShortVersionString" "$app_info_plist")
    date=$(date +%Y%m%d_%H%M%S)
    app_dist_file="${product_dir}/${scheme}_${short_version}_${version}_${date}.${app_dist_file_ext}"

    case $app_dist_file_ext in
        "tar.xz")
            tarxz $(basename $export_app) $app_dist_file
            ;;
        "zip")
            zip $export_app $app_dist_file
            ;;
        *)
            echo unsupportted file type
            ;;
    esac

    if [ $? -ne 0 ]; then
        echo create dist file with staple ticket failed!
        exit -1
    fi

    echo dist file of app: $app_dist_file
}

function write_appcast_xml() {
    sparkle_generate_appcast=$sparkle_bin/generate_appcast
    $sparkle_generate_appcast $product_dir

    # change url
    app_dist_file_name=$(basename $app_dist_file)
    url_pattern="https://.*${app_dist_file_name//./\\.}"
    target_url=${git_url%%.git}/releases/download/${short_version}/${app_dist_file_name}
    target_url=${target_url//./\\.}
    # echo pattern: $url_pattern
    # echo target: $target_url
    sed -i'' -e  "s|${url_pattern}|${target_url}|" $product_dir/appcast.xml
}

function clean_products() {
    remove $product_dir/*.zip $product_dir/*.tar.xz
}

function cleanup() {
    remove $client_dir/*.zip   \
        *.plist *.log          \
        $build_dir $derived_data_path $export_app
}
cleanup && clean_products && build && sparkle && archive && write_export_options_plist && export && notarize && sparkle && distribute "zip" && write_appcast_xml && cleanup