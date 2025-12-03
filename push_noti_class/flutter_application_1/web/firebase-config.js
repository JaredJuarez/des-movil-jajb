import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.10/firebase-app.js";
import { getMessaging } from "https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging.js";

const firebaseConfig = {
  apiKey: "AIzaSyDxXASNHDbhpMQLUbcyb1lVaj2lZhgX2rk",
  authDomain: "fir-4c-21c06.firebaseapp.com",
  projectId: "fir-4c-21c06",
  storageBucket: "fir-4c-21c06.firebasestorage.app",
  messagingSenderId: "611820996568",
  appId: "1:611820996568:web:52d8b08fe934dde5f494ad"
};

const app = initializeApp(firebaseConfig);

// necesario para evitar errores incluso si no se usa inmediatamente
getMessaging(app);
