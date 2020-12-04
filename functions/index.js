const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const db = admin.firestore();
exports.sendNotificationToTopic = functions.firestore.document('latest_deals/{dealId}').onWrite(async  (change, context) => {
console.log(change);
    var deal = change.after.data();
    var dealName =  deal.brand;

    const querySnapshot = await db.collectionGroup('profile').where('brands', 'array-contains', dealName).where('notificationEnable', '==', true).get();
    querySnapshot.forEach((doc) => {
        console.log(doc.id, ' => ', doc.data());
        var data = doc.data();
        var message ={
            notification: {
                title: "New Sale",
                body: dealName + " deal just launched"

            },
            "token": data.token
        };

        let response=admin.messaging().send(message);
        console.log(response);
    });
});