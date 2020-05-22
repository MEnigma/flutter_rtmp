package holo.mark.flutter_rtmp

import io.flutter.plugin.common.*
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterRtmpPlugin {


    companion object {
        lateinit var registrar: Registrar

        @JvmStatic
        fun registerWith(registrar: Registrar) {

            /// 静态变量
            FlutterRtmpPlugin.registrar = registrar

            val rtmpmanager: RtmpManagerV2 = RtmpManagerV2()
            MethodChannel(registrar.messenger(), DEF_CAMERA_SETTING_CONFIG).setMethodCallHandler(rtmpmanager)
            val viewfactory: RtmpPreviewFactory = RtmpPreviewFactory(rtmpmanager)
            /// 注册视图
            registrar.platformViewRegistry().registerViewFactory(DEF_CAMERA_RTMP_VIEW, viewfactory)


        }
    }

}
