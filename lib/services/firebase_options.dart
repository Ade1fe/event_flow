// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     if (kIsWeb) {
//       return web;
//     }
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.android:
//         return android;
//       case TargetPlatform.iOS:
//         return ios;
//       case TargetPlatform.macOS:
//         return macos;
//       case TargetPlatform.windows:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for windows - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       case TargetPlatform.linux:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions have not been configured for linux - '
//           'you can reconfigure this by running the FlutterFire CLI again.',
//         );
//       default:
//         throw UnsupportedError(
//           'DefaultFirebaseOptions are not supported for this platform.',
//         );
//     }
//   }

//   static const FirebaseOptions web = FirebaseOptions(
//     apiKey: 'your-web-api-key',
//     appId: 'your-web-app-id',
//     messagingSenderId: 'your-sender-id',
//     projectId: 'your-project-id',
//     authDomain: 'your-project-id.firebaseapp.com',
//     storageBucket: 'your-project-id.appspot.com',
//   );

//   static const FirebaseOptions android = FirebaseOptions(
//     apiKey: 'AIzaSyC...', // Your actual Android API key
//     appId: '1:123456789:android:...', // Your actual Android App ID
//     messagingSenderId: '123456789', // Your actual sender ID
//     projectId: 'your-actual-project-id', // Your actual project ID
//     storageBucket: 'your-actual-project-id.appspot.com',
//   );

//   static const FirebaseOptions ios = FirebaseOptions(
//     apiKey: 'AIzaSyD...', // Your actual iOS API key
//     appId: '1:123456789:ios:...', // Your actual iOS App ID
//     messagingSenderId: '123456789', // Your actual sender ID
//     projectId: 'your-actual-project-id', // Your actual project ID
//     storageBucket: 'your-actual-project-id.appspot.com',
//     iosBundleId: 'com.example.taskMasterPro',
//   );

//   static const FirebaseOptions macos = FirebaseOptions(
//     apiKey: 'your-macos-api-key',
//     appId: 'your-macos-app-id',
//     messagingSenderId: 'your-sender-id',
//     projectId: 'your-project-id',
//     storageBucket: 'your-project-id.appspot.com',
//     iosBundleId: 'com.example.taskMasterPro',
//   );
// }
