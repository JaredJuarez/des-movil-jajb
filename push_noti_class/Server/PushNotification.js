const admin = require('firebase-admin');



// Carga del archivo de credenciales del service account

const serviceAccount = require('./serviceAccountKey.json');


// Inicializar el SDK de Firebase Admin

admin.initializeApp({

    credential: admin.credential.cert(serviceAccount),

});



// TODO: pega aquí el token FCM que te dio la app Flutter

const deviceToken = 'BLWZsWlPbEWOBo0SalcTS8lFeyp_2JU04oxqTaazqctktW4K8oEW5AepWJseS1bGanFExkrDEXe_Fyfnli5ruQI';



async function sendPush() {

    const message = {

        token: deviceToken,

        notification: {

            title: 'Hola desde Firebase Admin',

            body: 'Este es un mensaje enviado con la API v',

        },

        data: {

            origen: 'node-demo',

            tipo: 'prueba',

        },

    };



    try {

        const response = await admin.messaging().send(message);

        console.log('✅ Mensaje enviado correctamente:', response);

    } catch (error) {

        console.error('❌ Error al enviar mensaje:', error);

    }

}



sendPush();
