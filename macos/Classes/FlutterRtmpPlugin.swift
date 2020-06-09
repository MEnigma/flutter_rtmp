import FlutterMacOS
import Foundation

public class FlutterRtmpPlugin:NSObject,FlutterPlugin{
    public static func register(with registrar: FlutterPluginRegistrar) {
        TextureController.registerWithRegistrar(with: registrar)
        
    }
    
  
}
