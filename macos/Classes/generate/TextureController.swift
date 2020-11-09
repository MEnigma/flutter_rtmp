//
//  PreviewFactory.swift
//  flutter_rtmp
//
//  Created by Apple on 2020/6/2.
//

import Foundation
import FlutterMacOS

public class TextureController : NSObject{
        
    var textureRegistry : FlutterTextureRegistry? = nil
    var messenger : FlutterBinaryMessenger?=nil
    var buffer : TextureBuffer?=nil
    

    class func registerWithRegistrar(with registrar:FlutterPluginRegistrar ){
        let methodChannel : FlutterMethodChannel = FlutterMethodChannel(name: RtmpDefine.RTMP_SETTING_CONFIG_KEY(), binaryMessenger: registrar.messenger)
        let controller : TextureController = TextureController()
        controller.textureRegistry = registrar.textures
        controller.messenger = registrar.messenger
        methodChannel.setMethodCallHandler(controller.handle)
    }
    
    // 处理上层事件
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "initConfig"{
            self.buffer = nil
            self.buffer = TextureBuffer()
            self.buffer?.initBuffer()
        }else{
            
        }
    }
    
}
