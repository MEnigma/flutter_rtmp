package holo.mark.flutter_rtmp

import android.content.Context
import android.hardware.Camera
import android.util.Log
import android.view.View
import android.widget.Toast
import com.github.faucamp.simplertmp.RtmpHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import net.ossrs.yasea.SrsCameraView
import net.ossrs.yasea.SrsCameraView.CameraCallbacksHandler
import net.ossrs.yasea.SrsEncodeHandler
import net.ossrs.yasea.SrsPublisher
import net.ossrs.yasea.SrsRecordHandler
import java.io.IOException
import java.net.SocketException

class RtmpFactory : PlatformViewFactory(StandardMessageCodec()) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return RtmpView(context)
    }
}

class RtmpView(context: Context?) : PlatformView {
    private var context: Context? = context
    private var manager: RtmpManager? = null

    override fun dispose() {
        if (manager != null) {
            manager?.dispose()
            manager = null
        }
    }

    override fun getView(): View {
        if (manager == null) {
            manager = RtmpManager(context)
        }
        return manager?.getView() ?: View(context)
    }
}

class RtmpManager(context: Context?) : MethodChannel.MethodCallHandler,
        SrsEncodeHandler.SrsEncodeListener, RtmpHandler.RtmpListener,
        SrsRecordHandler.SrsRecordListener {

    private var cameraView: SrsCameraView?
    private lateinit var publisher: SrsPublisher
    private var config: RtmpConfig
    private var context: Context? = null
    private var logger: RtmpLoger = RtmpLoger()
    private var hasConfig: Boolean = false

    init {
        this.context = context
        cameraView = SrsCameraView(context)
        cameraView?.cameraId = 1
        config = RtmpConfig()
        initPublisher()
        MethodChannel(FlutterRtmpPlugin.registrar.messenger(), DEF_CAMERA_SETTING_CONFIG)
                .setMethodCallHandler(this)
    }

    private fun initPublisher() {
        publisher = SrsPublisher(cameraView)
        publisher.setEncodeHandler(SrsEncodeHandler(this))
        publisher.setRtmpHandler(RtmpHandler(this))
        publisher.setRecordHandler(SrsRecordHandler(this))
        publisher.setPreviewResolution(640, 360)
        publisher.setOutputResolution(360, 640)
        publisher.setVideoHDMode()
        publisher.startCamera()

        cameraView?.setCameraCallbacksHandler(object : CameraCallbacksHandler() {
            override fun onCameraParameters(params: Camera.Parameters) {
                //params.setFocusMode("custom-focus");                
                //params.setWhiteBalance("custom-balance");
                //etc...
            }
        })

    }

    fun getView(): View {
        if (cameraView == null) {
            initPublisher()
        }
        stopAction()
        hasConfig = false
        logger.state = RTMP_STATUE_Refresh
        publisher.startCamera()
        return cameraView!!
    }

    fun dispose() {
        stopAction()
        cameraView = null
    }

    private fun stopAction(): Boolean {
        try {
            publisher.stopRecord()
            publisher.stopPublish()

        } catch (e: Exception) {
            Log.e(TAG,"[ RTMP ] stop error : $e")
            return false
        }
        return true
    }

    private fun previewAction(): Boolean {
        return try {
            publisher.startCamera()
            true

        } catch (e: Exception) {
            false
        }
    }

    private fun publishAction(): Boolean {
        try {
            if (!previewAction()) {
                return false
            }
            publisher.startPublish(logger.rtmpUrl)
        } catch (e: Exception) {
            return false
        }
        return true
    }

    private fun switchCameraAction(): Boolean {
        try {
            var cameraId = publisher.cameraId
            cameraId = if (cameraId == 0) {
                1
            } else {
                0
            }
            publisher.switchCameraFace(cameraId)

        } catch (e: Exception) {
            return false
        }
        return true
    }

    private fun initConfig(param: Map<String, Any>, result: MethodChannel.Result) {
        try {
            @Suppress("UNCHECKED_CAST")
            config.init(param as Map<String, Map<String, Any>>)
            result.success(Response().succeessful())
        } catch (e: Exception) {
            result.success(Response().failure(e.toString()))
        }
    }

    private fun startLive(param: Map<String, String>, result: MethodChannel.Result) {
        val url: String? = param["url"]
        if (url == null) {
            result.success(Response().failure("address is unavailable"))
        }
        logger.rtmpUrl = url ?: ""
        try {
            if (publishAction()) {
                result.success(Response().succeessful())
            } else {
                result.success(Response().failure("Live streaming start error"))
            }

        } catch (e: Exception) {
            result.success(Response().failure(e.toString()))
        }
    }

    private fun stopLive(result: MethodChannel.Result) {
        if (stopAction()) {
            result.success(Response().succeessful())
        } else {
            result.success(Response().failure(""))
        }
    }

    private fun getCameraRatio(result: MethodChannel.Result) {
        val res: MutableMap<String, Any> = Response().succeessful()
        result.success(res)
    }

    private fun switchCamera(result: MethodChannel.Result) {
        if (switchCameraAction()) {
            result.success(Response().succeessful())
        } else {
            result.success(Response().failure(""))
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        val param: Map<String, Any> = call.arguments as Map<String, Any>
        when (call.method) {
            "startLive" -> {
                @Suppress("UNCHECKED_CAST")
                startLive(param as Map<String, String>, result)
            }
            "initConfig" -> {
                initConfig(param, result)
            }
            "stopLive" -> {
                stopLive(result)
            }
            "rotateCamera" -> {
            }
            "dispose" -> {
                dispose()
            }
            "cameraRatio" -> {
                getCameraRatio(result)
            }
            "switchCamera" -> {
                switchCamera(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onEncodeIllegalArgumentException(e: IllegalArgumentException?) {
        handleException(e)
    }

    override fun onNetworkWeak() {
        showToast("Network problems")
    }

    override fun onNetworkResume() {
        showToast("Network problems resolved")
    }

    private fun handleException(exception: Exception?) {
        try {
            Toast.makeText(context?.applicationContext, exception?.message, Toast.LENGTH_SHORT).show()
            publisher.stopPublish()
            publisher.stopRecord()
//            btnPublish.setText("publish")
//            btnRecord.setText("record")
//            btnSwitchEncoder.setEnabled(true)
        } catch (_: Exception) {
        }
    }

    override fun onRtmpConnected(message: String?) {
        showToast(message)
    }

    override fun onRtmpIllegalStateException(e: IllegalStateException?) {
        handleException(e)
    }

    override fun onRtmpStopped() {
        showToast("Stopped")
    }

    override fun onRtmpIOException(e: IOException?) {
        handleException(e)
    }

    override fun onRtmpAudioStreaming() {
    }

    override fun onRtmpSocketException(e: SocketException?) {
        handleException(e)
    }

    override fun onRtmpDisconnected() {
        showToast("Disconnected")
    }

    override fun onRtmpVideoFpsChanged(fps: Double) {
        Log.i(TAG, String.format("Output Fps: %f", fps))
    }

    override fun onRtmpConnecting(message: String?) {
        message?.let { showToast(it) }
    }

    override fun onRtmpVideoStreaming() {
    }

    override fun onRtmpAudioBitrateChanged(bitrate: Double) {
        val rate = bitrate.toInt()
        if (rate / 1000 > 0) {
            Log.i(TAG, String.format("Audio bitrate: %f kbps", bitrate / 1000))
        } else {
            Log.i(TAG, String.format("Audio bitrate: %d bps", rate))
        }
    }

    override fun onRtmpVideoBitrateChanged(bitrate: Double) {
        val rate = bitrate.toInt()
        if (rate / 1000 > 0) {
            Log.i(TAG, String.format("Video bitrate: %f kbps", bitrate / 1000))
        } else {
            Log.i(TAG, String.format("Video bitrate: %d bps", rate))
        }
    }

    override fun onRtmpIllegalArgumentException(e: IllegalArgumentException?) {
        handleException(e)
    }

    private fun showToast(message: String?) {
        Toast.makeText(context?.applicationContext, message ?: "Error", Toast.LENGTH_SHORT).show()
    }

    companion object {
        const val TAG = "RtmpManager"
    }

    override fun onRecordIOException(e: IOException?) {
        handleException(e)
    }

    override fun onRecordIllegalArgumentException(e: IllegalArgumentException?) {
        handleException(e)
    }

    override fun onRecordFinished(p0: String?) {
        showToast("MP4 file saved")
    }

    override fun onRecordPause() {
        showToast("Recording paused")
    }

    override fun onRecordResume() {
        showToast("Recording resumed")
    }

    override fun onRecordStarted(message: String?) {
        showToast("Recording started $message")
    }
}