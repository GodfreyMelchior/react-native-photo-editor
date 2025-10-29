# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

React Native Photo Editor (RNPE) is a native image editor module for React Native that wraps platform-specific native libraries:
- **iOS**: ZLImageEditor (https://github.com/longitachi/ZLImageEditor)
- **Android**: PhotoEditor (https://github.com/burhanrashid52/PhotoEditor)

**Important**: The implementation differs significantly between iOS and Android. Always test changes on both platforms.

## Development Commands

### Setup
```bash
yarn                    # Install dependencies
yarn bootstrap          # Install all dependencies including example app and pods
yarn pods               # Install iOS pods for example app
```

### Building & Testing
```bash
yarn prepare            # Build the library using react-native-builder-bob
yarn typescript         # Type-check TypeScript files
yarn lint               # Run ESLint
yarn lint --fix         # Fix linting errors
yarn test               # Run Jest tests
```

### Example App
```bash
yarn example start      # Start Metro bundler
yarn example ios        # Run example app on iOS
yarn example android    # Run example app on Android
```

### Release
```bash
yarn release            # Publish new version using release-it
```

## Architecture

### JavaScript Layer
- **Entry point**: `src/index.tsx` - Simple bridge module with TypeScript definitions
- Exports a single `open(options)` method that returns a Promise with the edited image path
- Options include `path` (image URL/path) and `stickers` (array of sticker URLs/paths)

### iOS Architecture
- **Main bridge**: `ios/PhotoEditor.swift` - Objective-C/Swift bridge
- **Native editor**: Wraps ZLImageEditor library in `ios/ZLImageEditor/`
- **Filter system**: Custom LUT-based color filters in `ios/FilterColorCube/`
  - Filters use cube data from LUT images stored in `LUTs.bundle`
  - Filter naming convention: `LUT_64_FILTER_NAME`
- **Stickers**: Loaded from `Stickers.bundle` or remote URLs via SDWebImage
- **Layout**: Uses embedded SnapKit for constraint-based layouts
- Uses SDWebImage for remote image loading

### Android Architecture
- **Main bridge**: `android/src/main/java/com/reactnativephotoeditor/PhotoEditorModule.kt`
- **Activity**: `PhotoEditorActivity.kt` - Full-screen editor UI with bottom sheets
- **Native editor**: Uses ja.burhanrashid52.photoeditor library
- **Filters**: MediaEffect-based filters (future plan to switch to LUT)
- **Stickers**: Loaded from `assets/Stickers/` folder + remote URLs via Glide
- **UI Components**: Bottom sheet fragments for tools, properties, shapes, text editing

### Response Flow
1. JS calls `PhotoEditor.open(options)` with image path and stickers
2. Native module presents full-screen editor activity/view controller
3. User edits image and saves or cancels
4. Native code saves to Pictures directory (Android) or Documents (iOS)
5. Promise resolves with `file://` path to edited image or rejects with error code

### Error Codes
- `USER_CANCELLED` - User cancelled editing
- `IMAGE_LOAD_FAILED` / `LOAD_IMAGE_FAILED` - Failed to load source image
- `ACTIVITY_DOES_NOT_EXIST` - Android activity doesn't exist
- `FAILED_TO_SAVE_IMAGE` - Save operation failed
- `DONT_FIND_IMAGE` - Image path not provided

## Native Development

### iOS
- Open `example/ios/PhotoEditorExample.xcworkspace` in Xcode
- Native source files located under `Pods > Development Pods > react-native-photo-editor`
- Requires Swift 5.1+ and iOS 12+
- Add `:modular_headers => true` for SDWebImage pods in Podfile

### Android
- Open `example/android` in Android Studio
- Native source files under `reactnativephotoeditor` module
- Activity uses Material Design bottom sheets and ConstraintLayout animations

## Custom Assets

### iOS Filters
1. Create `LUTs.bundle` with LUT images named `LUT_64_FILTER_NAME.png`
2. Add bundle to Xcode target under "Copy Bundle Resources"
3. ColorCubeLoader automatically loads all LUT files from bundle

### iOS Stickers
1. Create `Stickers.bundle` with sticker images
2. Add bundle to "Copy Bundle Resources" in Xcode

### Android Stickers
1. Create `assets/Stickers/` folder in Android app
2. Add sticker images to this folder

## Code Style

### Commits
Follow conventional commits:
- `fix:` - Bug fixes
- `feat:` - New features
- `refactor:` - Code refactoring
- `docs:` - Documentation changes
- `test:` - Test updates
- `chore:` - Tooling changes

Pre-commit hooks enforce linting and TypeScript checks.

### Formatting
- ESLint with Prettier
- Single quotes, 2-space indentation, trailing commas (es5)
- Run `yarn lint --fix` before committing

## Platform Differences

| Feature | iOS | Android |
|---------|-----|---------|
| Filters | LUT-based (ColorCube) | MediaEffect (planned: LUT) |
| Crop | ✅ Available (ZLImageEditor) | ✅ Available (uCrop library) |
| Rotate | Manual gesture | ✅ 90° rotation button |
| Drawing | Basic | Advanced (shapes, eraser, opacity) |
| Remote images | SDWebImage | Glide |
| Stickers | Bundle + remote | Assets + remote |

When implementing cross-platform features, verify behavior on both platforms due to different native implementations.

## Android Crop & Rotate Implementation

### Crop Feature
- Uses **uCrop library** (v2.2.8) by Yalantis
- Free aspect ratio cropping with max result size of 2000x2000
- Cropped images are cached temporarily in app cache directory
- Activity result launcher pattern for handling crop results

### Rotate Feature
- Rotates the actual bitmap 90 degrees clockwise on each tap
- Uses Android Matrix transformation to rotate the bitmap
- Saves rotated bitmap to cache and reloads into the image view
- Rotation persists through save operation

### Files Modified for Crop/Rotate
- `android/src/main/java/com/reactnativephotoeditor/activity/tools/ToolType.java` - Added CROP and ROTATE enum values
- `android/src/main/java/com/reactnativephotoeditor/activity/tools/EditingToolsAdapter.java` - Added crop/rotate to tool list
- `android/src/main/java/com/reactnativephotoeditor/activity/PhotoEditorActivity.kt` - Implemented crop/rotate handlers
- `android/src/main/res/drawable/ic_crop.xml` - Crop icon vector drawable
- `android/src/main/res/drawable/ic_rotate.xml` - Rotate icon vector drawable
- `android/src/main/res/values/strings.xml` - Added label_crop and label_rotate strings
- `android/build.gradle` - Added uCrop dependency
- `android/src/main/AndroidManifest.xml` - Registered UCropActivity
