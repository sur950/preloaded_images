package com.example.preloadedImages.preloaded_images;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Application;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.provider.Settings;
import android.util.Log;

import com.karumi.dexter.Dexter;
import com.karumi.dexter.PermissionToken;
import com.karumi.dexter.listener.PermissionDeniedResponse;
import com.karumi.dexter.listener.PermissionGrantedResponse;
import com.karumi.dexter.listener.PermissionRequest;
import com.karumi.dexter.listener.single.PermissionListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** PreloadedImagesPlugin */
public class PreloadedImagesPlugin implements MethodCallHandler {
  Activity activity;
  int latestImageLimit;
  MethodChannel methodChannel;
  private Application.ActivityLifecycleCallbacks activityLifecycleCallbacks;
  Result result;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "preloaded_images");
    channel.setMethodCallHandler(new PreloadedImagesPlugin(registrar.activity(), channel, registrar));
  }

  public PreloadedImagesPlugin(Activity activity, MethodChannel methodChannel, Registrar registrar) {
    this.activity = activity;
    this.methodChannel = methodChannel;
    this.methodChannel.setMethodCallHandler(this);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
      this.activityLifecycleCallbacks = new Application.ActivityLifecycleCallbacks() {
        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
          latestImageLimit = 10;
        }

        @Override
        public void onActivityStarted(Activity activity) {
        }

        @Override
        public void onActivityResumed(Activity activity) {

          getPermissionResult(result, activity);

        }

        @Override
        public void onActivityPaused(Activity activity) {

        }

        @Override
        public void onActivityStopped(Activity activity) {

        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
        }
      };
    }

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    this.result = result;
    if (call.method.equals("getImages")) {
      latestImageLimit = call.argument("count");
      getPermissionResult(result, activity);
    } else {
      result.notImplemented();
    }
  }

  public void getPermissionResult(final Result result, final Activity activity) {
    Dexter.withActivity(activity).withPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        .withListener(new PermissionListener() {
          @Override
          public void onPermissionGranted(PermissionGrantedResponse response) {
            result.success(getAllImageList(activity));
          }

          @Override
          public void onPermissionDenied(PermissionDeniedResponse response) {

            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setMessage("This permission is needed to fetch images from storage, Kindly click Allow.");
            builder.setTitle("Storage Permission Request");
            builder.setCancelable(false);
            builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
              public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                Uri uri = Uri.fromParts("package", activity.getPackageName(), null);
                intent.setData(uri);
                activity.startActivity(intent);

              }
            });
            builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
              public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
              }
            });
            AlertDialog alert = builder.create();
            alert.show();

          }

          @Override
          public void onPermissionRationaleShouldBeShown(PermissionRequest permission, final PermissionToken token) {

            AlertDialog.Builder builder = new AlertDialog.Builder(activity);
            builder.setMessage("This permission is needed to fetch images from storage, Kindly click Allow.");
            builder.setTitle("Storage Permission Request");
            builder.setCancelable(false);
            builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
              public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
                token.continuePermissionRequest();

              }
            });
            builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
              public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
                token.cancelPermissionRequest();
              }
            });
            AlertDialog alert = builder.create();
            alert.show();
          }
        }).check();

  }

  public List getAllImageList(Activity activity) {

    ArrayList<String> allImageList = new ArrayList<>();

    Uri uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
    String[] projection = { MediaStore.Images.ImageColumns.DATA, MediaStore.Images.ImageColumns.DISPLAY_NAME,
        MediaStore.Images.ImageColumns.DATE_ADDED, MediaStore.Images.ImageColumns.TITLE };
    Cursor c = activity.getContentResolver().query(uri, projection, null, null,
        MediaStore.Images.ImageColumns.DATE_TAKEN + " DESC");
    if (c != null) {
      while (c.moveToNext()) {
        allImageList.add(c.getString(0));
        if (allImageList.size() == latestImageLimit) {
          break;
        }
      }
      c.close();
    }
    return allImageList;
  }
}
