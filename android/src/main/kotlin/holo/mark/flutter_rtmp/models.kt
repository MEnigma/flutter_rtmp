package holo.mark.flutter_rtmp

import android.content.*
import android.content.res.Configuration
import android.util.*
import kotlin.Pair

class ErrCode {
    companion object {
        var None: Int = 0               // 无错误
        var RepeatOperation: Int = 1    // 重复操作
        var UnKnown: Int = 2            // 未知错误
    }
}

/// 回调
class Response {

    /// 错误码
    private var errorCode: Int = ErrCode.None

    /// 操作状态
    private var succeed: Boolean = false

    /// 信息
    private var message: String = ""

    private var result: MutableMap<String, Any> = mutableMapOf()

    fun setValue(code: Int, succeed: Boolean, message: String, result: MutableMap<String, Any>) : Map<String,Any> {
        errorCode = code
        this.succeed = succeed
        this.message = message
        this.result = result
        return toJson()
    }
    @Deprecated("使用 setValue")
    fun succeessful(): MutableMap<String, Any> {
        succeed = true
        return toJson()
    }
    @Deprecated("使用 setValue")
    fun succeessfulWithCode(code: Int): MutableMap<String, Any> {
        succeed = true
        errorCode = code
        return toJson()
    }

    @Deprecated("使用 setValue")
    fun failure(msg: String?): MutableMap<String, Any> {
        succeed = false
        message = msg ?: ""
        return toJson()
    }

    private fun toJson(): MutableMap<String, Any> {
        val res = mutableMapOf(
                Pair("succeed", succeed),
                Pair("message", message),
                Pair("code", errorCode),
                Pair("result", result)
        )
        println(">> [Mark Rtmp] Response : $res")
        return res
    }

}

/// 直播信息配置
class RtmpConfig {

    var videoConfig: RtmpVideoConfig = RtmpVideoConfig()
    var audioConfig: RtmpAudioConfig = RtmpAudioConfig()

    fun init(param: Map<String, Map<String, Any>?>?) {
        if (param == null) return
        val vConfgi: Map<String, Any>? = param["videoConfig"] ?: mapOf()
        videoConfig.init(vConfgi)

    }

}

/// 音频配置,暂不支持
class RtmpAudioConfig {}

class RtmpVideoConfig {
    // 自动旋转
    var autoRotate: Boolean = false

    // 视频输出质量 1.2.3
    var quality: Int = 2

    // 预览尺寸
    var previewSize: Size? = null

    // output尺寸
    var outputSize: Size? = null

    // 是否自适应尺寸
    var autoSize: Boolean = true

    //竖屏
    var orientation = Configuration.ORIENTATION_PORTRAIT

    // 是否有加载
    private var didload: Boolean = false

    fun init(param: Map<String, Any?>?) {
        autoRotate = (param?.get("autoRotate") ?: false) as Boolean

        val inputQuality: Int = (param?.get("quality") ?: 2) as Int
        quality = 4 - (if (inputQuality <= 2) 1 else if (inputQuality <= 5) 2 else 3)

        // 尺寸
        val autoSize: Boolean = (param?.get("autoSize") ?: true) as Boolean
        if (!autoSize) {
            val preW: Int = (param?.get("previewWidth") ?: 0) as Int
            val preH: Int = (param?.get("previewHeight") ?: 0) as Int
            if (preH > 0 && preW > 0) {
                this.autoSize = false
            }
        }
        didload = true
    }

    fun isPortrail(): Boolean {
        return orientation == Configuration.ORIENTATION_PORTRAIT
    }
}


/// rtmp 记录信息
class RtmpLoger {
    var currentCtxSize: Size = Size(0, 0)

    var rtmpUrl: String = ""

    /// 连接状态
    var status: Int = RTMP_STATUE_Preparing

    /// 是否可以暂停
    fun canPause(): Boolean = status == RTMP_STATUE_Pushing || status == RTMP_STATUE_Pending

    /// 是否可以开始/重启
    fun canResume(): Boolean = status == RTMP_STATUE_Stop

    /// 正在推流
    fun rtmpInPushing(): Boolean {
        return status == RTMP_STATUE_Pushing || status == RTMP_STATUE_Pending
    }

//    fun loadContext(context: Context?) {
//        currentCtxSize = Size(640, 340)
//    }

    fun toMap(): MutableMap<String, Any> {
        return mutableMapOf(
                Pair("rtmpUrl", rtmpUrl),
                Pair("status", status),
                Pair("previewWidth", currentCtxSize.width),
                Pair("previewHeight", currentCtxSize.height)
        )
    }

}