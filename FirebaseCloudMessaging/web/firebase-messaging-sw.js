// Importar scripts de Firebase
importScripts('https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.0/firebase-messaging-compat.js');

// Configuración de Firebase - USA LOS MISMOS VALORES QUE EN TU index.html
firebase.initializeApp({
  apiKey: "TU_API_KEY",
  authDomain: "notificaciones-push-4f038.firebaseapp.com",
  projectId: "notificaciones-push-4f038",
  storageBucket: "notificaciones-push-4f038.appspot.com",
  messagingSenderId: "1096246907540",
  appId: "1:1096246907540:web:dfc790356582ae2db29a81"
});

// Obtener la instancia de Firebase Messaging
const messaging = firebase.messaging();

// Manejar mensajes en segundo plano
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  // Personalizar notificación
  const notificationTitle = payload.notification?.title || 'Título predeterminado';
  const notificationOptions = {
    body: payload.notification?.body || 'Cuerpo predeterminado',
    icon: '/icons/Icon-192.png', // Asegúrate de tener este icono
    badge: '/icons/Icon-192.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});