importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
firebase.initializeApp({
  apiKey: "Your Firebase Api key",
  authDomain: "Your Firebase Auth Domain",
  projectId: "Your Firebase Project Id",
  storageBucket: "Your Firebase Storage Bucket Id",
  messagingSenderId: "Your Firebase Messaging Sender Id",
  appId: "Your Firebase App Id",
  measurementId: "Your Firebase Measurement Id",
});
const messaging = firebase.messaging();
