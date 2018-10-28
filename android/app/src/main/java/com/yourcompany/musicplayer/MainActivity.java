package com.yourcompany.musicplayer;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;

import android.os.Environment;
import android.util.Base64;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.io.*;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  MediaMetadataRetriever metaRetriver;
  byte[] art;
  Map<String, String> song;
  Uri file;
  Intent intent;
  int requestcode = 1;
  @TargetApi(Build.VERSION_CODES.M)
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    try {
      intent = getIntent();
      String action = intent.getAction();
      String[] permissions = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
      if (action == Intent.ACTION_VIEW) {
        requestPermissions(permissions, requestcode);
//        handle(intent);
        new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
            if (methodCall.method.contentEquals("getSharedData")) {
              result.success(song);
            }
          }
        });
      }
    }catch (Exception e){
      Log.d("cdve",e.getMessage());
    }
  }

}
