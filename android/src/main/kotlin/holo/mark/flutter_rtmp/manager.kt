package holo.mark.flutter_rtmp

import android.content.Context
import android.graphics.Camera
import android.view.View
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import me.lake.librestreaming.ws.StreamAVOption
import me.lake.librestreaming.ws.StreamLiveCameraView
import java.io.IOException
import java.lang.Exception
import java.lang.IllegalArgumentException
import java.lang.IllegalStateException
import java.net.SocketException
import kotlin.math.log
import kotlin.math.max
import kotlin.math.min

class RtmpFactory : PlatformViewFactory(StandardMessageCodec()) {
//    lateinit var view: RtmpView

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        println("[ RTMP ] enter factory $context, viewid : $viewId")
        return RtmpView(context)
    }
}

class RtmpView(context: Context?) : PlatformView {
    private var _context: Context? = context
    private var _manager: RtmpManager? = null

    override fun dispose() {
        println("[ RTMP ] will dispose manager from rtmpview : $_manager")
        if (_manager != null) {
            _manager?.dispose()
            _manager = null
        }
    }

    override fun getView(): View {
        if (_manager == null) {
            _manager = RtmpManager(_context)
        }
        println("[ RTMP ] will get view from rtmpview : $_manager")
        return _manager?.getView() ?: View(_context)
    }
}

class RtmpManager(context: Context?) : MethodChannel.MethodCallHandler {

    private var preVie: StreamLiveCameraView?
    private var config: RtmpConfig
    private var _context: Context? = null
    private var loger: RtmpLoger = RtmpLoger()
    private var _hasConfig: Boolean = false

    init {
        _context = context
//        cameraView = SrsCameraView(context)
        preVie = StreamLiveCameraView(context)

        config = RtmpConfig()
        _initPublisher()

        /// 注册配置回调方法
        MethodChannel(FlutterRtmpPlugin.registrar.messenger(), DEF_CAMERA_SETTING_CONFIG).setMethodCallHandler(this)
    }

    fun _initPublisher() {
        if (preVie == null)
            preVie = StreamLiveCameraView(_context)
        val option: StreamAVOption = StreamAVOption()
        preVie?.init(_context, option)
    }

    //--------------------------- public ---------------------------
    fun getView(): View {
        if (preVie == null) {
            _initPublisher()
        }
        stopAction()
        _hasConfig = false
        loger.state = RTMP_STATUE_Refresh
        return preVie ?: View(_context)
    }

    fun dispose() {
        stopAction()
        preVie?.destroy()
        preVie = null
    }

    //--------------------------- private ---------------------------
    private fun loadConfig(clear: Boolean) {

        stopAction()
        if (clear) {
            preVie = null
            _initPublisher()
        }

    }

    /// 终止活动
    private fun stopAction(): Boolean {
        try {
            preVie?.stopRecord()
            preVie?.stopStreaming()

        } catch (e: Exception) {
            println("[ RTMP ] stop error : $e")
            return false
        }
        return true
    }

    /// 开始预览-不推流
    private fun previewAction(): Boolean {
        try {
//            publisher?.startCamera()

        } catch (e: Exception) {
            return false
        }
        return true
    }

    private fun publishAction(): Boolean {
        try {
            if (!previewAction()) {
                return false
            }

            preVie?.startStreaming(loger.rtmpUrl)
        } catch (e: Exception) {
            return false
        }
        return true
    }

    // 选择摄像头
    private fun switchCameraAction(): Boolean {
        try {
            preVie?.swapCamera()
        } catch (e: Exception) {
            return false
        }
        return true
    }

    //--------------------------- 方法执行 ---------------------------

    /// 默认配置,不执行配置,仅做保存
    fun initConfig(param: Map<String, Any>, result: MethodChannel.Result) {
        try {
            @Suppress("UNCHECKED_CAST")
            config.init(param as Map<String, Map<String, Any>>)
            result.success(Response().succeessful())
        } catch (e: Exception) {
            result.success(Response().failure(e.toString()))
        }
    }

    /// 开始直播
    fun startLive(param: Map<String, String>, result: MethodChannel.Result) {
        val url: String? = param["url"]
        if (url == null) {
            result.success(Response().failure("address is unavailable"))
        }
        loger.rtmpUrl = url ?: ""
        try {
            if (publishAction()) {
                result.success(Response().succeessful())
            } else {
                result.success(Response().failure("直播开始错误"))
            }

        } catch (e: Exception) {
            result.success(Response().failure(e.toString()))
        }
    }

    // 暂停
    fun pauseLive(result: MethodChannel.Result) {
        if (stopAction()) {
            result.success(Response().succeessful())
        } else {
            result.success(Response().failure(""))
        }
    }

    // 恢复
    fun resumeLive(result: MethodChannel.Result) {
        if (publishAction()) {
            result.success(Response().succeessful())
        } else {
            result.success(Response().failure(""))
        }
    }

    // 停止
    fun stopLive(result: MethodChannel.Result) {
        if (stopAction()) {
            result.success(Response().succeessful())
        } else {
            result.success(Response().failure(""))
        }
    }

    fun getCameraRatio(result: MethodChannel.Result) {

        val res: MutableMap<String, Any> = Response().succeessful()
        result.success(res)
    }

    fun switchCamera(result: MethodChannel.Result) {
        if (switchCameraAction()) {
            result.success(Response().succeessful())
        } else {
            result.success(Response().failure(""))
        }
    }

    //--------------------------- 消息方法监听 ---------------------------
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        val param: Map<String, Any> = call.arguments as Map<String, Any>
        if (call.method.equals("startLive")) {
            @Suppress("UNCHECKED_CAST")
            startLive(param as Map<String, String>, result)
        } else if (call.method.equals("initConfig")) {
            initConfig(param, result)
        } else if (call.method.equals("stopLive")) {
            stopLive(result)
        } else if (call.method.equals("rotateCamera")) {

        } else if (call.method.equals("pauseLive")) {
            stopLive(result)
        } else if (call.method.equals("resumeLive")) {
            resumeLive(result)
        } else if (call.method.equals("dispose")) {
            dispose()
        } else if (call.method.equals("cameraRatio")) {
            getCameraRatio(result)
        } else if (call.method.equals("switchCamera")) {
            switchCamera(result)
        } else {
            result.notImplemented()
        }
    }

}