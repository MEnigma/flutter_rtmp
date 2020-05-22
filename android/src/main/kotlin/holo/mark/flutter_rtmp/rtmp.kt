package holo.mark.flutter_rtmp

import android.app.*
import android.content.*
import android.content.res.*
import android.hardware.camera2.*
import android.util.*
import android.view.*
import androidx.appcompat.app.*
import com.github.faucamp.simplertmp.*
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.*
import net.ossrs.yasea.*
import java.io.*
import java.lang.Exception
import java.lang.IllegalArgumentException
import java.lang.IllegalStateException
import java.net.*


class RtmpPreviewFactory(rtmpManagerV2: RtmpManagerV2) : PlatformViewFactory(StandardMessageCodec()) {
    private var _rtmpmanager: RtmpManagerV2 = rtmpManagerV2
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return RtmpPreviewV2(_rtmpmanager, context)
    }
}

// preview maker
class RtmpPreviewV2(managerV2: RtmpManagerV2, context: Context?) : PlatformView {
    private var _manager: RtmpManagerV2 = managerV2
    private var _context: Context? = context
    override fun getView(): View {
        return _manager.getView(_context) ?: View(_context)
    }

    override fun dispose() {

    }
}

// rtmp control
class RtmpManagerV2 : AppCompatActivity(), MethodChannel.MethodCallHandler, SrsEncodeHandler.SrsEncodeListener, RtmpHandler.RtmpListener, SrsRecordHandler.SrsRecordListener {
    private var preview: SrsCameraView? = null
    private var config: RtmpConfig = RtmpConfig()
    private var loger: RtmpLoger = RtmpLoger()
    private var pusher: SrsPublisher? = null

    private fun checkPreview(context: Context?) {
        if (preview == null) {
            preview = SrsCameraView(context)
        }
        if (pusher == null) {
            pusher = SrsPublisher(preview)
        }
    }

    fun getView(context: Context?): SrsCameraView? {
        checkPreview(context)
        loger.currentCtxSize = getContextSize(context)
//        loadConfig()
//        pusher?.startCamera()
        return preview
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        print(">> TTT ------------------------------------------------------------------------\n")
        val param: Map<String, Any>
        if (call.arguments != null) {
            @Suppress("UNCHECKED_CAST")
            param = call.arguments as Map<String, Any>
        } else {
            param = mapOf()
        }
        logat(call.method, param)
        when (call.method) {
            "initConfig" -> setConfig(param, result)
            "startLive" -> startLive(param, result)
            "stopLive" -> endLive(param, result)
            "pauseLive" -> pauseLive(param, result)
            "resumeLive" -> resumeLive(param, result)
            "dispose" -> dispose()
            "cameraRatio" -> cameraRatio(param, result)
            "switchCamera" -> swatchCamera(param, result)
            "rotateOrientation" -> rotateOrientation(param, result)
            else -> result.notImplemented()
        }
    }

    private fun dispose() {
        preview = null
        pusher = null
    }

    //--------------------------------------- private -----------------------------------------
    private fun loadConfig() {
        pusher?.setEncodeHandler(SrsEncodeHandler(this))
        pusher?.setRecordHandler(SrsRecordHandler(this))
        pusher?.setRtmpHandler(RtmpHandler(this))
        pusher?.setPreviewResolution(loger.currentCtxSize.height / 2, loger.currentCtxSize.width / 2)
        pusher?.setOutputResolution(loger.currentCtxSize.width / 2, loger.currentCtxSize.height / 2)
        pusher?.setVideoSmoothMode()
        loger.status = RTMP_STATUE_Ready
    }

    private fun getContextSize(context: Context?): Size {
        val displayMetrics: DisplayMetrics = DisplayMetrics()
        val windowManager: WindowManager? = context?.getSystemService(Context.WINDOW_SERVICE) as WindowManager?
        windowManager?.defaultDisplay?.getMetrics(displayMetrics)
        return Size(displayMetrics.widthPixels, displayMetrics.heightPixels)
    }

    private fun setConfig(param: Map<String, Any>, result: MethodChannel.Result) {
        try {
            @Suppress("UNCHECKED_CAST")
            config.init(param as Map<String, Map<String, Any>>)
            loadConfig()
            pusher?.startCamera()
            result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
        } catch (e: Exception) {
            result.success(Response().setValue(ErrCode.UnKnown, false, e.toString(), loger.toMap()))
        }
    }

    private fun rotateOrientation(param: Map<String, Any>, result: MethodChannel.Result) {
        val force: Boolean = param["force"] as Boolean
        val origin: Int = param["orien"] as Int
        val indexori = FlutterRtmpPlugin.registrar.activity().resources.configuration.orientation - 1
        if (!force && indexori == origin) {
            result.success(Response().setValue(ErrCode.RepeatOperation, false, "", loger.toMap()))
            return
        }
        pusher?.stopEncode()
        pusher?.stopCamera()
        pusher?.setScreenOrientation(indexori + 1)
        pusher?.startCamera()
        result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
    }

    private fun startLive(param: Map<String, Any>, result: MethodChannel.Result) {
        if (loger.rtmpInPushing()) {
            result.success(Response().setValue(ErrCode.RepeatOperation, false, "", loger.toMap()))
            return
        }
        val url: String? = param["url"] as String
        loger.rtmpUrl = url ?: ""
        pusher?.startPublish(loger.rtmpUrl)
        pusher?.startCamera()
        result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
    }

    private fun endLive(param: Map<String, Any>, result: MethodChannel.Result) {
        if (!loger.rtmpInPushing()) {
            result.success(Response().setValue(ErrCode.RepeatOperation, false, "", loger.toMap()))
            return
        }
        pusher?.stopPublish()
        result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
    }

    private fun swatchCamera(param: Map<String, Any>, result: MethodChannel.Result) {
        var numOfCamera: Int
        var errmsg: String = "ok"
        try {
            val manager: CameraManager = FlutterRtmpPlugin.registrar.activity().getSystemService(Context.CAMERA_SERVICE) as CameraManager
            numOfCamera = manager.cameraIdList.count()
        } catch (e: Exception) {
            numOfCamera = 2
            errmsg = e.toString()
        }
        val nextCameraId: Int = (pusher?.cameraId ?: 0) + 1
        pusher?.switchCameraFace(nextCameraId % numOfCamera)
        result.success(Response().setValue(ErrCode.None, true, errmsg, loger.toMap()))
    }

    private fun pauseLive(param: Map<String, Any>, result: MethodChannel.Result) {
        if (loger.rtmpInPushing()) {
            pusher?.stopPublish()
            pusher?.startCamera()
            result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
        } else {
            result.success(Response().setValue(ErrCode.RepeatOperation, false, "", loger.toMap()))
        }
    }

    private fun resumeLive(param: Map<String, Any>, result: MethodChannel.Result) {
        if (!loger.rtmpInPushing()) {
            pusher?.startPublish(loger.rtmpUrl)
            result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
        } else {
            result.success(Response().setValue(ErrCode.RepeatOperation, false, "", loger.toMap()))
        }
    }

    private fun cameraRatio(param: Map<String, Any>, result: MethodChannel.Result) {
        result.success(Response().setValue(ErrCode.None, true, "ok", loger.toMap()))
    }

    private fun logat(message: String, param: Map<String, Any>) {
        println(">> [Flutter RTMP] $message --> param : $param")
    }

    //--------------------------------------- LISTENER -----------------------------------------

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        pusher?.stopEncode()
        pusher?.setScreenOrientation(newConfig.orientation)
        pusher?.startCamera()
    }

    /// encode listener
    override fun onEncodeIllegalArgumentException(e: IllegalArgumentException?) {
    }

    override fun onNetworkResume() {
    }

    override fun onNetworkWeak() {
    }

    /// rtmp handler
    override fun onRtmpAudioBitrateChanged(bitrate: Double) {
    }

    override fun onRtmpAudioStreaming() {
    }

    override fun onRtmpConnected(msg: String?) {
        loger.status = RTMP_STATUE_Pushing
    }

    override fun onRtmpConnecting(msg: String?) {
        loger.status = RTMP_STATUE_Pending
    }

    override fun onRtmpDisconnected() {
        loger.status = RTMP_STATUE_Stop
    }

    override fun onRtmpIOException(e: IOException?) {
        loger.status = RTMP_STATUE_Error
    }

    override fun onRtmpIllegalArgumentException(e: IllegalArgumentException?) {
    }

    override fun onRtmpIllegalStateException(e: IllegalStateException?) {
    }

    override fun onRtmpSocketException(e: SocketException?) {
    }

    override fun onRtmpStopped() {
        loger.status = RTMP_STATUE_Stop
    }

    override fun onRtmpVideoBitrateChanged(bitrate: Double) {
    }

    override fun onRtmpVideoFpsChanged(fps: Double) {
    }

    override fun onRtmpVideoStreaming() {
        loger.status = RTMP_STATUE_Pushing
    }


    /// record handler

    override fun onRecordFinished(msg: String?) {
    }

    override fun onRecordIOException(e: IOException?) {
    }

    override fun onRecordIllegalArgumentException(e: IllegalArgumentException?) {
    }

    override fun onRecordPause() {
    }

    override fun onRecordResume() {
    }

    override fun onRecordStarted(msg: String?) {
    }
}