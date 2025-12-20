const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Trigger when user document is updated and send notification for newly unlocked badges
exports.onUserBadgesUpdated = functions.firestore
  .document('users/{uid}')
  .onUpdate(async (change, context) => {
    const before = change.before.data() || {};
    const after = change.after.data() || {};

    const beforeBadges = Array.isArray(before.badges) ? before.badges : [];
    const afterBadges = Array.isArray(after.badges) ? after.badges : [];

    // Find newly added badges
    const newBadges = afterBadges.filter(b => !beforeBadges.includes(b));
    if (newBadges.length === 0) {
      return null;
    }

    const fcmToken = after.fcmToken;
    if (!fcmToken) {
      console.log('No FCM token for user', context.params.uid);
      return null;
    }

    // For each new badge, send a notification
    const promises = newBadges.map(badgeId => {
      const payload = {
        notification: {
          title: 'Badge Unlocked!',
          body: `You unlocked ${badgeId}`,
        },
        data: {
          badgeId: badgeId,
        },
      };
      return admin.messaging().sendToDevice(fcmToken, payload);
    });

    return Promise.all(promises).then(results => {
      console.log('Sent badge notifications:', results.length);
      return null;
    }).catch(err => {
      console.error('Error sending badge notifications', err);
    });
  });
