import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _lastTitle = 'Sin notificaciones';
  String _lastBody = '';
  String _token = 'Obteniendo token...';

  @override
  void initState() {
    super.initState();

    _getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (notification != null) {
        setState(() {
          _lastTitle = notification.title ?? 'Sin título';
          _lastBody = notification.body ?? 'Sin contenido';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notificación: ${notification.title ?? 'Sin título'}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<void> _getToken() async {
    try {
      // Solicitar permisos de notificación primero
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      print('Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Usuario dio permiso para notificaciones');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('Usuario dio permiso provisional');
      } else {
        print('Usuario denegó permisos');
      }

      // Obtener el token
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _token = token ?? 'No se pudo obtener el token';
      });
      print('Token FCM: $token');
    } catch (e) {
      setState(() {
        _token = 'Error al obtener token: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Última notificación recibida:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Título:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_lastTitle, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    const Text(
                      'Contenido:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastBody.isEmpty ? 'Sin contenido' : _lastBody,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔑 Token FCM:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(_token, style: const TextStyle(fontSize: 11)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _getToken,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Actualizar Token'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📱 Instrucciones para enviar notificación de prueba:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Ve a Firebase Console\n'
                    '2. Selecciona tu proyecto\n'
                    '3. Ve a Cloud Messaging\n'
                    '4. Haz clic en "Enviar tu primer mensaje"\n'
                    '5. Escribe un título y mensaje\n'
                    '6. Selecciona la aplicación y envía',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
