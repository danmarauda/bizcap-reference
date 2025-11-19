# KONSTRUKT app.json Update & Tool Limitation

This document summarizes the recent attempt to prepare the `KONSTRUKT` application (`~/rork/rork-ai-assistant-construction`) for TestFlight/App Store submission, specifically focusing on the `app.json` configuration.

## 1. Objective

The goal was to update the `app.json` file of the `KONSTRUKT` project to reflect its correct identity and include more descriptive permission strings, a necessary step for App Store review.

## 2. Original `app.json` Configuration

The `app.json` file contained generic placeholder values:

```json
{
  "expo": {
    "name": "AI ASSISTANT Construction",
    "slug": "mastra-voice-ai-q7r7s-nlujywey",
    "version": "1.0.0",
    "ios": {
      "bundleIdentifier": "app.rork.mastra-voice-ai-q7r7s-nlujywey",
      "infoPlist": {
        "NSPhotoLibraryUsageDescription": "Allow $(PRODUCT_NAME) to access your photos",
        "NSCameraUsageDescription": "Allow $(PRODUCT_NAME) to access your camera",
        "NSMicrophoneUsageDescription": "Allow $(PRODUCT_NAME) to access your microphone",
        "UIBackgroundModes": [
          "audio"
        ]
      },
      "usesIcloudStorage": true
    },
    "android": {
      "package": "app.rork.mastra-voice-ai-q7r7s-nlujywey",
    }
  }
}
```

## 3. Proposed Changes

The following updates were proposed to align `app.json` with the `KONSTRUKT` project's identity and App Store requirements:

-   **`name`**: "KONSTRUKT"
-   **`slug`**: "konstrukt"
-   **`ios.bundleIdentifier`**: "com.rork.konstrukt"
-   **`android.package`**: "com.rork.konstrukt"
-   **iOS Permission Descriptions**: Made more specific and user-friendly.

The `new_string` for the `replace` operation was:

```json
{
  "expo": {
    "name": "KONSTRUKT",
    "slug": "konstrukt",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/images/icon.png",
    "scheme": "myapp",
    "userInterfaceStyle": "automatic",
    "newArchEnabled": true,
    "splash": {
      "image": "./assets/images/splash-icon.png",
      "resizeMode": "contain",
      "backgroundColor": "#ffffff"
    },
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.rork.konstrukt",
      "infoPlist": {
        "NSPhotoLibraryUsageDescription": "KONSTRUKT needs access to your photo library to allow you to upload site photos, attach images to reports, and update your profile picture.",
        "NSCameraUsageDescription": "KONSTRUKT needs access to your camera to allow you to take and upload site photos for reports and analysis.",
        "NSMicrophoneUsageDescription": "KONSTRUKT needs access to your microphone for voice commands, real-time transcription, and recording audio notes.",
        "UIBackgroundModes": [
          "audio"
        ]
      },
      "usesIcloudStorage": true
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/images/adaptive-icon.png",
        "backgroundColor": "#ffffff"
      },
      "package": "com.rork.konstrukt",
      "permissions": [
        "CAMERA",
        "READ_EXTERNAL_STORAGE",
        "WRITE_EXTERNAL_STORAGE",
        "INTERNET",
        "RECORD_AUDIO",
        "android.permission.VIBRATE"
      ]
    },
    "plugins": [
      "expo-router",
      [
        "expo-image-picker",
        {
          "photosPermission": "The app accesses your photos to let you share them with your friends."
        }
      ],
      [
        "expo-document-picker",
        {
          "iCloudContainerEnvironment": "Production"
        }
      ],
      [
        "expo-av",
        {
          "microphonePermission": "Allow KONSTRUKT to access your microphone"
        }
      ]
    ],
    "experiments": {
      "typedRoutes": true
    }
  }
}
```

## 4. Issue Encountered: Tool Limitation

The `replace` tool failed to apply the changes due to a file path restriction. The error message was:

```
File path must be within one of the workspace directories: /Users/alias/bizcap-reference
```

This indicates that while I can read files using `run_shell_command` with paths outside the current working directory (`/Users/alias/bizcap-reference`), tools like `replace` and `write_file` are restricted to modifying files *within* the current working directory.

The `KONSTRUKT` project (`~/rork/rork-ai-assistant-construction`) resides outside `/Users/alias/bizcap-reference`, preventing direct modification by these tools.

## 5. Next Steps / Resolution Options

To proceed with modifying `KONSTRUKT`'s `app.json` (or any other files within the `~/rork` directory):

1.  **Relocate the `rork` directory:** The `~/rork` directory (or specific projects within it) could be moved or copied into the current working directory (`/Users/alias/bizcap-reference`). This would bring the files within the tool's writable scope.
2.  **Manual Application:** The proposed changes can be applied manually by the user.