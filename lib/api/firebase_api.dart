import 'package:firebase_messaging/firebase_messaging.dart';

// Handle background messages (must be top-level function)
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  //create an instance of Firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  //function to initialise notifications
  Future<void> initNotifications() async {
    try {
      //request permission from user
      await _firebaseMessaging.requestPermission();

      //fetch the FCM token for this device
      final fCMToken = await _firebaseMessaging.getToken();

      //print the token (normally you would send this to your server)
      print('Token: $fCMToken');
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      });
      
    } catch (e) {
      print('Error initializing notifications: $e');
      // Continue app execution even if notification setup fails
    }
  }
}