import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // Importación para Clipboard
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? token;
  String status = 'Inicializando...';

  // Función para copiar al portapapeles
  Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✓ Token copiado al portapapeles"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error copying to clipboard: $e');
      
      // Fallback: mostrar diálogo con el token
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Token - Copia manualmente"),
          content: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              text,
              style: TextStyle(fontFamily: 'RobotoMono', fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cerrar"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    try {
      if (kIsWeb) {
        print('Configurando para entorno web...');
      }

      // Solicitar permisos
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Permission status: ${settings.authorizationStatus}');
      
      // Obtener token
      token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
      
      setState(() {
        status = 'Token obtenido correctamente';
      });

      // Escuchar mensajes en primer plano
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Mensaje en primer plano: ${message.notification?.title}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("📲 Notificación: ${message.notification?.title ?? 'Nueva notificación'}"),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.green,
          ),
        );
      });

    } catch (e) {
      print('Error configurando notificaciones: $e');
      setState(() {
        status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actividad Notificaciones"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado
            Card(
              color: status.contains('Error') ? Colors.red[100] : Colors.green[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estado:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(status),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Token
            Text(
              "Token del dispositivo:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                token ?? "Cargando token...",
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Instrucciones
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Instrucciones:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text("1. Copia el token de arriba"),
                    Text("2. Ve a Firebase Console > Engage > Messaging"),
                    Text("3. Crea una nueva campaña de notificación"),
                    Text("4. En 'Target' selecciona 'Single device'"),
                    Text("5. Pega el token y envía la notificación"),
                    SizedBox(height: 8),
                    Text(
                      "Nota: En web, las notificaciones solo se muestran cuando la pestaña está activa.",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange[800]),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Botones de acción
            Row(
              children: [
                ElevatedButton(
                  onPressed: initializeNotifications,
                  child: Text("Reintentar Configuración"),
                ),
                SizedBox(width: 10),
                if (token != null)
                  ElevatedButton(
                    onPressed: () => copyToClipboard(token!),
                    child: Text("Copiar Token"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}