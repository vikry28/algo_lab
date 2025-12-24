# Cloud Function: Badge notifications

This Cloud Function listens to `users/{uid}` document updates and sends FCM notifications to the user's device when a new badge is added to the `badges` array.

How to deploy:

1. Install Firebase CLI and login:

```bash
npm install -g firebase-tools
firebase login
```

2. From this repository root, navigate to `functions` and install dependencies:

```bash
cd functions
npm install
```

3. Initialize Firebase project (if not already) and deploy functions:

```bash
firebase init functions
firebase deploy --only functions:onUserBadgesUpdated
```

Notes:
- The function expects `users/{uid}` documents to have `fcmToken` field containing the device FCM token.
- The app already updates `fcmToken` via `FirestoreService.updateFcmToken` in `main.dart` during startup.
