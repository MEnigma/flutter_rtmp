//
//  RmParam.swift
//  flutter_rtmp
//
//  Created by Apple on 2020/6/1.
//

import Foundation


public class VideoConfig : BaseModel{
    var autoRotate : Bool = false
    var quality: Int = 0
    var orientation: RtmpOrientation = RtmpOrientation.Portrait
}

public class AudioConfig : BaseModel{
    
}

public class RtmpConfig : BaseModel{
    var videoConfig : VideoConfig = VideoConfig()
    var audioConfig : AudioConfig = AudioConfig()
    
}
