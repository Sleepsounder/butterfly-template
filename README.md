# Butterfly Flutter template

## Overview

The template, `butterfly`, is Flutter starter application without any code modification.

### Quick Install

The following steps will quickly get you up and running and testing with this mobile app.

1. Run the application on a simulator

   ```bash
   > open -a Simulator
   > flutter run
   ```

   If for some reason this does not work, then get a list of simulators and explicitly tell Flutter which device upon which to run your app.

   ```bash
   > flutter devices

   1 connected device:
   iPhone 11 Pro Max • FD112899-2F2C-4DD7-930A-0B348B6E3882 • ios • com.apple.CoreSimulator.SimRuntime.iOS-13-3 (simulator)

   > flutter run -t ./lib/main_dev.dart -d fd11
   ```

### Errors

If you experience errors, it is likely that you do not have all of the requisite dependencies installed. Please ensure that you do. Follow the instructions, below.

If it turns out that you do have all of the dependencies installed and you are still experiencing errors, please create a new Issue.

## Install Dependencies

1. Install [Flutter](https://flutter.dev/docs/get-started/install)
   1. [MacOS Flutter install instructions](https://flutter.dev/docs/get-started/install/macos)
   1. [Windows Flutter install instructions](https://flutter.dev/docs/get-started/install/windows)
1. Install [VSCode Flutter and Dart plugins](https://flutter.dev/docs/get-started/editor?tab=vscode)
1. Install [build runner](https://dart.dev/tools/build_runner)
1. Run `flutter doctor` from the terminal
   1. Review output
   1. Resolve any issues

If there are any issues with iOS / XCode or Android, you may need to re-install certain dependencies.

1. Install [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
1. Install [Android Studio](https://developer.android.com/studio/install)
