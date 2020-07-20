const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.updateSchedule = functions.firestore.document('Majors/{majorId}').onUpdate(
    async (snapshot) => {
        const status = snapshot.after.data().status;
        const name = snapshot.after.data().name;
        console.log("Data update : name: " + name + " status: " + status);
    }
);

exports.createSchedule = functions.firestore.document('Majors/{majorId}').onCreate(
    async (snapshot) => {
      // Notification details.
      const text = snapshot.data().name;
      const status = snapshot.data().status;
      console.log("Data created name: " + text + " status: " + status);
    //   const payload = {
    //     notification: {
    //       title: `${snapshot.data().name} posted ${text ? 'a message' : 'an image'}`,
    //       body: text ? (text.length <= 100 ? text : text.substring(0, 97) + '...') : '',
    //       icon: snapshot.data().profilePicUrl || '/images/profile_placeholder.png',
    //       click_action: `https://${process.env.GCLOUD_PROJECT}.firebaseapp.com`,
    //     }
    //   };
  
    //   // Get the list of device tokens.
    //   const allTokens = await admin.firestore().collection('fcmTokens').get();
    //   const tokens = [];
    //   allTokens.forEach((tokenDoc) => {
    //     tokens.push(tokenDoc.id);
    //   });
  
    //   if (tokens.length > 0) {
    //     // Send notifications to all tokens.
    //     const response = await admin.messaging().sendToDevice(tokens, payload);
    //     await cleanupTokens(response, tokens);
    //     console.log('Notifications have been sent and tokens cleaned up.');
    //   }
    });

// exports.update = functions.firestore.document('Majors/{id}').onUpdate((snapshot, context) => {
//     print("update : " + snapshot.data());
// });

// exports.sendNewTripNotification = functions.database.ref('/{uid}/shared_trips/').onWrite(event=>{
//     const uuid = event.params.uid;

//     console.log('User to send notification', uuid);

//     var ref = admin.database().ref(`Users/${uuid}/token`);
//     return ref.once("value", function(snapshot){
//          const payload = {
//               notification: {
//                   title: 'You have been invited to a trip.',
//                   body: 'Tap here to check it out!'
//               }
//          };

//          admin.messaging().sendToDevice(snapshot.val(), payload)

//     }, function (errorObject) {
//         console.log("The read failed: " + errorObject.code);
//     });
// })


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
