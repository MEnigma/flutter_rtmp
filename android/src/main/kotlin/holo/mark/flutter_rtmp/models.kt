package holo.mark.flutter_rtmp

import android.content.res.Configuration



/// 回调
class Response {

    /// 操作状态
    private var succeed: Boolean = false

    /// 信息
    private var message: String = ""

    fun succeessful(): MutableMap<String,Any> {
        succeed = true
        return toJson()
    }

    fun failure(msg: String?): MutableMap<String,Any> {
        succeed = false
        message = msg ?: ""
        return toJson()
    }

    private fun toJson(): MutableMap<String,Any> {
        return mutableMapOf(
                Pair("succeed", succeed),
                Pair("message", message)
        )
    }

}

/// 直播信息配置
class RtmpConfig {

    var videoConfig: RtmpVideoConfig = RtmpVideoConfig()
    var audioConfig: RtmpAudioConfig = RtmpAudioConfig()

    fun init(param: Map<String, Map<String, Any>?>?) {
        if (param == null) return
        val vConfgi: Map<String, Any>? = param.get("videoConfig") as Map<String, Any>
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

    //竖屏
    var orientation = Configuration.ORIENTATION_PORTRAIT

    fun init(param: Map<String, Any?>?) {
        autoRotate = (param?.get("autoRotate") ?: false) as Boolean

        val inputQuality: Int = (param?.get("quality") ?: 2) as Int
        quality = 4 - (if (inputQuality <= 2) 1 else if (inputQuality <= 5) 2 else 3)
    }

    fun isPortrail(): Boolean {
        return orientation == Configuration.ORIENTATION_PORTRAIT
    }

}


/// rtmp 记录信息
class RtmpLoger {

    var rtmpUrl: String = ""

    /// 连接状态
    var state: Int = RTMP_STATUE_Preparing

    /// 是否可以暂停
    fun canPause(): Boolean = state == RTMP_STATUE_Pushing || state == RTMP_STATUE_Pending

    /// 是否可以开始/重启
    fun canResume() : Boolean = state == RTMP_STATUE_Stop


}