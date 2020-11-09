//
//  TextureBuffer.swift
//  flutter_rtmp
//
//  Created by Apple on 2020/6/2.
//

import Foundation
import FlutterMacOS
import AVFoundation

public class TextureBuffer:NSObject,AVCaptureVideoDataOutputSampleBufferDelegate{
    var eventChannel : FlutterEventChannel? = nil
    var captureSession : AVCaptureSession?=nil
    var captureDeviceInput : AVCaptureDeviceInput?=nil
    var captureDevice : AVCaptureDevice?=nil
    var captureOutput : AVCaptureVideoDataOutput?=nil
//    public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
//
//    }
    
    // 初始化
    func initBuffer(){
        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = AVCaptureSession.Preset(rawValue: AVAssetExportPreset640x480)
        
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        if devices.count>0{
            captureDevice = devices.first
        }else{
            print("无设备")
        }
        
        do {
            captureDeviceInput = try AVCaptureDeviceInput.init(device: captureDevice!)
        } catch  {
            print("AVCaptureDeviceInput 初始化失败")
            return
        }
        
        captureOutput = AVCaptureVideoDataOutput()
        captureOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        captureOutput?.alwaysDiscardsLateVideoFrames=true
        captureOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        let connection : AVCaptureConnection = AVCaptureConnection(inputPorts: captureDeviceInput!.ports, output: captureOutput!)
        captureSession?.addInputWithNoConnections(captureDeviceInput!)
        captureSession?.addOutputWithNoConnections(captureOutput!)
        captureSession?.addConnection(connection)
    }
    func start(){
        captureSession?.startRunning()
    }
    func stop(){
        captureSession?.stopRunning()
    }
    
    
    //------------------------ 代理 ------------------------
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("output")
    }
}
