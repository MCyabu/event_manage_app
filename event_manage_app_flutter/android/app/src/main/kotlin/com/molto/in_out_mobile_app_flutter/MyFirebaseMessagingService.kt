// package com.molto.in_out_mobile_app_flutter

// import io.flutter.embedding.android.FlutterActivity

// import androidx.annotation.NonNull
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import android.content.Context
// import android.content.ContextWrapper
// import android.content.Intent
// import android.content.IntentFilter
// import android.os.Build.VERSION
// import android.os.Build.VERSION_CODES
// import android.app.NotificationManager;
// import android.app.NotificationChannel;
// import android.net.Uri;
// import android.media.AudioAttributes;
// import android.content.ContentResolver;
// import android.util.Log
// import com.google.firebase.messaging.FirebaseMessagingService
// import com.google.firebase.messaging.RemoteMessage

// import android.os.Bundle
// import android.app.PendingIntent
// import androidx.core.app.NotificationCompat
// import androidx.core.app.NotificationManagerCompat

// import java.util.UUID

// class MyFirebaseMessagingService : FirebaseMessagingService() {
//     val CHANNEL_ID = "1"

//     override fun onMessageReceived(message: RemoteMessage) {
//         super.onMessageReceived(message)

//         Log.d("onMessageReceived", "From: ${message.from}")
//         if (message.data.isNotEmpty()) {
//             Log.d("onMessageReceived", "payload: ${message.data}")
//         }

//         createNotificationChannel()
//         val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
//             .setContentTitle("入退ログ")
//             .setContentText("${message.data}」")
//             .setSmallIcon(R.mipmap.ic_launcher)
//             .setPriority(NotificationCompat.PRIORITY_DEFAULT)
//         with(NotificationManagerCompat.from(this)) {
//             notify(UUID.randomUUID().hashCode(), notificationBuilder.build())
//         }
//     }

//     private fun createNotificationChannel() {
//         if (VERSION.SDK_INT >= VERSION_CODES.O) {
//             val name = "入退ログ通知"
//             val descriptionText = "入退ログの通知です"
//             val importance = NotificationManager.IMPORTANCE_HIGH
//             val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
//                 description = descriptionText
//             }
//             // Register the channel with the system
//             val notificationManager: NotificationManager =
//                 getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//             notificationManager.createNotificationChannel(channel)
//         }
//     }
// }