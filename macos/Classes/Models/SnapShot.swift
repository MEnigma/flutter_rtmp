//
//  SnapShot.swift
//  flutter_rtmp
//
//  Created by Apple on 2020/6/2.
//

import Foundation

enum RtmpStatus:Int{
    /// 准备中
    case Ready = 0
    /// 连接中
    case Pending = 1
    /// 已连接
    case Pushing = 2
    /// 已断开
    case Stop = 3
    /// 连接出错
    case Error = 4
    ///  正在刷新
    case Refresh = 5

}

/// 快照信息
public class SnapShot : BaseModel{
    // 当前状态
    var status : RtmpStatus = RtmpStatus.Ready
    // 直播地址
    var rtmpUrl : String = ""
    // 预览尺寸宽度
    var previewWidth : Float = 0.0
    // 预览尺寸高度
    var previewHeight : Float = 0.0
    
}
