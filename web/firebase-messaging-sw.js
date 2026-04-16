importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBahMTfGYG2-z-y7ePyb40GE0nBi20GU9M",
  appId: "1:767046810526:web:2803b28b45b27c787b748f",
  messagingSenderId: "767046810526",
  projectId: "white-board-3",
  authDomain: "white-board-3.firebaseapp.com",
  storageBucket: "white-board-3.firebasestorage.app",
});

const messaging = firebase.messaging();
