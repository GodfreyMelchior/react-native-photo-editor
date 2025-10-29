# Testing Crop & Rotate Features

## Quick Test (Android)

1. **Install dependencies:**
   ```bash
   cd "/Users/apple/Documents/React Native Projects/react-native-photo-editor"
   npm install
   npm run prepare
   cd example
   npm install
   ```

2. **Run on Android:**
   ```bash
   # Make sure Android emulator is running or device is connected
   npm run android
   ```

3. **Test the features:**
   - Open the app
   - Select or capture an image
   - Look for the new **Crop** and **Rotate** buttons in the toolbar
   - Tap **Rotate** - image should rotate 90° clockwise
   - Tap **Crop** - cropping interface should open
   - Add some drawings or text
   - Tap **Save**
   - Verify the saved image has all edits including rotation and crop

## Quick Test (iOS)

```bash
cd example/ios
pod install
cd ..
npm run ios
```

## Using in Your Project

### Method 1: Local Installation
```bash
cd /path/to/your/react-native-project
npm install file:"/Users/apple/Documents/React Native Projects/react-native-photo-editor"
cd ios && pod install && cd ..
```

### Method 2: Direct Copy (Quick & Dirty)
Copy the entire `react-native-photo-editor` folder into your project's `node_modules/@baronha/` directory, then:
```bash
cd ios && pod install && cd ..
```

### Usage in Code:
```javascript
import PhotoEditor from '@baronha/react-native-photo-editor';

const handleEditImage = async () => {
  try {
    const editedPath = await PhotoEditor.open({
      path: 'file:///path/to/image.jpg', // or http://...
      stickers: [
        'https://example.com/sticker1.png',
        'https://example.com/sticker2.png'
      ]
    });

    console.log('Edited image saved at:', editedPath);
    // Use editedPath in your app (display, upload, etc.)

  } catch (error) {
    if (error === 'USER_CANCELLED') {
      console.log('User cancelled editing');
    } else {
      console.error('Error:', error);
    }
  }
};
```

## Troubleshooting

### Android Build Fails
- Clean build: `cd android && ./gradlew clean && cd ..`
- Check JDK version (should be 11 or 17)
- Check Android SDK is installed

### iOS Build Fails
- Clean build: `cd ios && xcodebuild clean && cd ..`
- Reinstall pods: `cd ios && rm -rf Pods && pod install && cd ..`
- Make sure Xcode is up to date

### Features Not Working
- Check logcat/console for errors
- Verify permissions are granted (storage for Android)
- Make sure image path is valid (use `file://` prefix for local files)

## New Features Added

✅ **Crop** - Full-screen crop interface with free aspect ratio
✅ **Rotate** - 90° clockwise rotation (tap multiple times for 180°, 270°, 360°)

Both features work with save operation and combine with other edits!
