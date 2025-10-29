#!/bin/bash

# Script to run React Native Android app with Java 17
# Usage: ./RUN_WITH_JAVA11.sh (updated to use Java 17)

echo "🔧 Setting up Java 17 environment..."

# Set JAVA_HOME to Java 17 (Gradle 7.4.2 compatible)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Set NODE_OPTIONS for Node.js 17+ compatibility
export NODE_OPTIONS=--openssl-legacy-provider

# Verify Java version
echo "✅ Using Java version:"
java -version

echo ""
echo "✅ Using Node.js version:"
node --version

echo ""
echo "🚀 Starting Android app build..."
echo ""

# Navigate to example directory
cd "/Users/apple/Documents/React Native Projects/react-native-photo-editor/example"

# Run the Android app
npx react-native run-android

echo ""
echo "✨ Done!"
