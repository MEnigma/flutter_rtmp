package holo.mark.flutter_rtmp

import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterRtmpPlugin  {


    companion object {
        lateinit var registrar: Registrar

        @JvmStatic
        fun registerWith(registrar: Registrar) {

            /// 静态变量
            FlutterRtmpPlugin.registrar = registrar

            /// 注册视图
            registrar.platformViewRegistry().registerViewFactory(DEF_CAMERA_RTMP_VIEW, RtmpFactory())


        }
    }

}
