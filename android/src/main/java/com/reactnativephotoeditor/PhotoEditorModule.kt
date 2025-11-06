package com.reactnativephotoeditor

import android.app.Activity
import android.content.Intent
import com.facebook.react.bridge.*
import com.reactnativephotoeditor.activity.PhotoEditorActivity
import com.reactnativephotoeditor.activity.constant.ResponseCode

enum class ERROR_CODE {

}

class PhotoEditorModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
  private val context = reactApplicationContext;
  private val EDIT_SUCCESSFUL = 1
  private var promise: Promise? = null
  override fun getName(): String {
    return "PhotoEditor"
  }

  @ReactMethod
  fun open(options: ReadableMap?, promise: Promise): Unit {
    this.promise = promise
    val activity = currentActivity
    if (activity == null) {
      promise.reject("ACTIVITY_DOES_NOT_EXIST", "Activity doesn't exist");
      return;
    }
    val intent = Intent(context, PhotoEditorActivity::class.java)
    context.addActivityEventListener(mActivityEventListener)

    val path = options?.getString("path")
    val stickers = options?.getArray("stickers") as ReadableArray
    val successDialog = options?.getMap("successDialog")

    intent.putExtra("path", path)
    intent.putExtra("stickers", stickers.toArrayList())

    // Pass success dialog options
    if (successDialog != null) {
      intent.putExtra("successDialogEnabled", if (successDialog.hasKey("enabled")) successDialog.getBoolean("enabled") else true)
      intent.putExtra("successDialogTitle", if (successDialog.hasKey("title")) successDialog.getString("title") else "Success")
      intent.putExtra("successDialogMessage", if (successDialog.hasKey("message")) successDialog.getString("message") else "Image saved successfully!")
      intent.putExtra("successDialogButtonText", if (successDialog.hasKey("buttonText")) successDialog.getString("buttonText") else "OK")
    } else {
      intent.putExtra("successDialogEnabled", true)
      intent.putExtra("successDialogTitle", "Success")
      intent.putExtra("successDialogMessage", "Image saved successfully!")
      intent.putExtra("successDialogButtonText", "OK")
    }

    activity.startActivityForResult(intent, EDIT_SUCCESSFUL)
  }

  private val mActivityEventListener: ActivityEventListener = object : BaseActivityEventListener() {
    override fun onActivityResult(activity: Activity, requestCode: Int, resultCode: Int, intent: Intent?) {
      if (requestCode == EDIT_SUCCESSFUL) {
        when (resultCode) {
          ResponseCode.RESULT_OK -> {
          val path = intent?.getStringExtra("path")
          promise?.resolve("file://$path")
          }
          ResponseCode.RESULT_CANCELED -> {
          promise?.reject("USER_CANCELLED", "User has cancelled", null)
          }
          ResponseCode.LOAD_IMAGE_FAILED -> {
            val path = intent?.getStringExtra("path")
            promise?.reject("LOAD_IMAGE_FAILED", "Load image failed: $path", null)
          }
          
        }
      }
    }
  }
}
