package com.molto.in_out_mobile_app_flutter

import io.flutter.embedding.android.FlutterActivity

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.net.Uri;
import android.media.AudioAttributes;
import android.content.ContentResolver;


class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.molto.in_out_mobile_app_flutter/channel" // チャンネルの名前

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      super.configureFlutterEngine(flutterEngine)
      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
        // FCMService()からのinvoke()
        call, result ->
        if (call.method == "createNotificationChannel"){
          val argData = call.arguments as java.util.HashMap<String, String>
            val isCompleted = createNotificationChannel(argData)
            if (isCompleted == true){
                result.success(isCompleted)
            }
            else{
                result.error("Error Code", "Error Message", null)
            }
        }
        else if(call.method == "deleteNotificationChannel"){
          val argData = call.arguments as java.util.HashMap<String, String>
          val isCompleted = deleteNotificationChannel(argData)
          if (isCompleted == true){
              result.success(isCompleted)
          }
          else{
              result.error("Error Code", "Error Message", null)
          }
        } 
        else {
          result.notImplemented()
        }
      }
  
    }
    // NotificationChannelの作成
    private fun createNotificationChannel(mapData: HashMap<String,String>): Boolean {
        val isCompleted: Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
            val importance = NotificationManager.IMPORTANCE_HIGH
            val myChannel = NotificationChannel(id, name, importance)
            myChannel.description = descriptionText
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(myChannel)
            isCompleted = true
        }
        else{
            isCompleted = false
        }
        return isCompleted
    }
    // NotificationChannelの削除
    private fun deleteNotificationChannel(mapData: HashMap<String,String>): Boolean {
      val isCompleted: Boolean
      if (VERSION.SDK_INT >= VERSION_CODES.O) {
          val id = mapData["id"]
          val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
          notificationManager.deleteNotificationChannel(id)
          isCompleted = true
      }
      else{
          isCompleted = false
      }
      return isCompleted
  }
}

