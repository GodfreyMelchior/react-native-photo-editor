# Running the Android Example App

## Issue Fixed
✅ Updated Gradle from 6.7.1 to 7.5.1 to support Java 17

## Steps to Run

### 1. Make Sure Android Device/Emulator is Connected

Check connected devices:
```bash
adb devices
```

You should see a device listed. If not:
- **For Emulator**: Open Android Studio → AVD Manager → Start an emulator
- **For Physical Device**: Enable USB debugging and connect via USB

### 2. Run the App

```bash
cd "/Users/apple/Documents/React Native Projects/react-native-photo-editor/example"
npx react-native run-android
```

**First time** will take 5-10 minutes as it:
- Downloads Gradle 7.5.1
- Downloads Android dependencies
- Builds the native code (including uCrop library)
- Compiles Kotlin code
- Installs the app

### 3. Alternative: Build in Android Studio

If the command line build is too slow or fails:

1. Open Android Studio
2. File → Open → Navigate to: `/Users/apple/Documents/React Native Projects/react-native-photo-editor/example/android`
3. Wait for Gradle sync to complete
4. Click the green "Run" button (▶️)

### 4. Start Metro Bundler (if needed)

If the app opens but shows "Unable to connect":
```bash
cd "/Users/apple/Documents/React Native Projects/react-native-photo-editor/example"
npx react-native start
```

## Testing the New Features

Once the app is running:

1. **Select an Image**
   - Tap one of the sample images on the home screen
   - OR take a photo with camera
   - OR select from gallery

2. **Photo Editor Opens**
   - You'll see the image in full screen
   - At the bottom, there's a horizontal toolbar with editing tools

3. **Test ROTATE** (NEW!)
   - Look for the circular arrow icon (🔄)
   - Tap it to rotate 90° clockwise
   - Tap multiple times for 180°, 270°, etc.

4. **Test CROP** (NEW!)
   - Look for the crop icon (⊏⊐)
   - Tap it to open the crop interface
   - Pinch, drag, and adjust the crop area
   - Tap the checkmark (✓) to apply

5. **Test Other Features**
   - **Shape**: Draw with brush/shapes
   - **Text**: Add text overlays
   - **Sticker**: Add sticker images
   - **Filter**: Apply color filters
   - **Eraser**: Erase drawings

6. **Save the Edited Image**
   - Tap "Save" button (top right)
   - Image saves to Pictures folder
   - All edits (including crop/rotate) are saved!

## Troubleshooting

### Build Still Failing?

1. **Clear Gradle Cache**:
```bash
cd "/Users/apple/Documents/React Native Projects/react-native-photo-editor/example/android"
./gradlew clean
rm -rf ~/.gradle/caches/
```

2. **Check Java Version** (Should be 11 or 17):
```bash
java -version
```

3. **Set JAVA_HOME** (if needed):
```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

### App Crashes on Launch?

Check logcat for errors:
```bash
adb logcat | grep -i "react\|error\|crash"
```

### Crop Button Not Visible?

The toolbar scrolls horizontally - swipe left on the toolbar to see Crop and Rotate buttons.

### Image Not Saving?

Grant storage permissions:
- Settings → Apps → PhotoEditorExample → Permissions → Storage → Allow

## Build Output

When successful, you'll see:
```
BUILD SUCCESSFUL in Xm Ys
✨  Installed the app successfully!
```

Then the app will launch automatically!

## Expected App Behavior

**Home Screen:**
- Grid of sample images
- "Take Photo" button
- "Select from Gallery" button

**Editor Screen:**
- Full-screen image view
- Top bar: Close (X) and Save buttons
- Bottom toolbar: Shape, Eraser, Filter, Sticker, Text, **Crop**, **Rotate**
- Undo/Redo buttons

**After Editing:**
- Returns to home screen
- Shows edited image path in console
- Edited image saved in device Pictures folder

Enjoy testing the new Crop & Rotate features! 🎉
