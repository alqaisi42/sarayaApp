#!/bin/bash

# Initialize variables
NEW_APP_NAME=""
NEW_VERSION=""
JKS_FILE=""
KEY_ALIAS=""
STORE_PASSWORD="mypassword"
KEY_PASSWORD="mypassword"
VALIDITY_DAYS=10000
FLUTTER_PROJECT_PATH="./"

# Determine the system's Documents folder
if [[ "$OSTYPE" == "darwin"* ]]; then
    DOCUMENTS_PATH="$HOME/Documents"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DOCUMENTS_PATH="$HOME/Documents"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    DOCUMENTS_PATH="$USERPROFILE/Documents"
else
    DOCUMENTS_PATH="$HOME"
fi

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            NEW_APP_NAME="$2"
            shift 2
            ;;
        --version)
            NEW_VERSION="$2"
            shift 2
            ;;
        --jks)
            JKS_FILE="$2"
            KEY_ALIAS="$3"
            shift 3
            ;;
        *)
            echo "❌ Unknown argument: $1"
            echo "Usage: ./change_app_name_and_jks.sh [--name \"New App Name\"] [--version \"1.2.0+3\"] [--jks \"keystore.jks\" \"keyAlias\"]"
            exit 1
            ;;
    esac
done

# Change app name if provided (but NOT in pubspec.yaml)
if [ -n "$NEW_APP_NAME" ]; then
    echo "🔄 Changing app name to: $NEW_APP_NAME"

    # Update Android app name
    ANDROID_MANIFEST="$FLUTTER_PROJECT_PATH/android/app/src/main/AndroidManifest.xml"
    if [ -f "$ANDROID_MANIFEST" ]; then
        sed -i '' "s/android:label=\"[^\"]*\"/android:label=\"$NEW_APP_NAME\"/" "$ANDROID_MANIFEST"
        echo "✅ Android app name updated in AndroidManifest.xml"
    else
        echo "⚠️ AndroidManifest.xml not found!"
    fi

    # Update iOS app name
    IOS_PLIST="$FLUTTER_PROJECT_PATH/ios/Runner/Info.plist"
    if [ -f "$IOS_PLIST" ]; then
        sed -i '' "s/<key>CFBundleDisplayName<\/key>\n\s*<string>[^<]*<\/string>/<key>CFBundleDisplayName<\/key>\n<string>$NEW_APP_NAME<\/string>/" "$IOS_PLIST"
        echo "✅ iOS app name updated in Info.plist"
    else
        echo "⚠️ Info.plist not found!"
    fi
fi

# Change app version if provided (only in pubspec.yaml)
if [ -n "$NEW_VERSION" ]; then
    echo "🔄 Changing app version to: $NEW_VERSION"

    PUBSPEC="$FLUTTER_PROJECT_PATH/pubspec.yaml"
    if [ -f "$PUBSPEC" ]; then
        sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
        echo "✅ App version updated in pubspec.yaml"
    else
        echo "⚠️ pubspec.yaml not found!"
    fi
fi

# Create JKS keystore file if requested
if [ -n "$JKS_FILE" ] && [ -n "$KEY_ALIAS" ]; then
    echo "🔐 Creating JKS keystore file: $JKS_FILE with alias: $KEY_ALIAS"

    JKS_PROJECT_PATH="$FLUTTER_PROJECT_PATH/android/app/$JKS_FILE"
    JKS_SYSTEM_PATH="$DOCUMENTS_PATH/$JKS_FILE"

    # Generate JKS in android/app and system's Documents folder
    keytool -genkey -v -keystore "$JKS_PROJECT_PATH" \
        -keyalg RSA -keysize 2048 -validity $VALIDITY_DAYS \
        -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD" \
        -alias "$KEY_ALIAS" -dname "CN=Your Name, OU=Your Organization, O=Your Company, L=Your City, ST=Your State, C=Your Country"

    cp "$JKS_PROJECT_PATH" "$JKS_SYSTEM_PATH"

    if [ -f "$JKS_PROJECT_PATH" ] && [ -f "$JKS_SYSTEM_PATH" ]; then
        echo "✅ Keystore file created in:"
        echo "   📂 $JKS_PROJECT_PATH (For Flutter)"
        echo "   📂 $JKS_SYSTEM_PATH (Backup in Documents)"
    else
        echo "❌ Keystore creation failed!"
        exit 1
    fi

    # Save keystore details in key.properties
    KEYSTORE_PROPERTIES="$FLUTTER_PROJECT_PATH/android/key.properties"
    echo "storeFile=$JKS_FILE" > "$KEYSTORE_PROPERTIES"
    echo "keyAlias=$KEY_ALIAS" >> "$KEYSTORE_PROPERTIES"
    echo "storePassword=$STORE_PASSWORD" >> "$KEYSTORE_PROPERTIES"
    echo "keyPassword=$KEY_PASSWORD" >> "$KEYSTORE_PROPERTIES"

    echo "✅ Keystore properties saved in key.properties"
fi

# Run flutter clean and get dependencies if any changes were made
if [ -n "$NEW_APP_NAME" ] || [ -n "$NEW_VERSION" ] || [ -n "$JKS_FILE" ]; then
    flutter clean
    flutter pub get
    echo "🚀 Changes applied successfully!"
else
    echo "⚠️ No changes made. Provide --name, --version, or --jks."
fi
