//
//  QrcodeVC.swift
//  二维码生成与扫描
//
//  Created by ljk on 17/11/10.
//

import UIKit

import Foundation
import AVFoundation

class QRCodeVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    
    let width = UIScreen.main.bounds.size.width
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "二维码扫描"
        self.view.backgroundColor = UIColor.red
        
//        let imageView = UIImageView(frame:CGRectMake((width-300)/2.0, 140, 300, 300))
//        imageView.image = UIImage(named:"pick_bg")
//        self.view.addSubview(imageView)
        
        
        let myButton = UIButton(type: UIButtonType.custom)
        myButton.frame = CGRect(x: 10, y: 30, width: 30, height: 30)

//        myButton.addTarget(self, action: dismiss, forControlEvents: UIControlEvents.TouchUpInside)
        myButton.addTarget(self, action: #selector(QRCodeVC.dismiss as (QRCodeVC) -> () -> ()), for: UIControlEvents.touchUpInside)
//        myButton.setTitle("返回", forState: UIControlState.Normal)
        myButton.setBackgroundImage(UIImage(named: "ocrBack"), for: UIControlState())
        self.view.addSubview(myButton)
        
    }
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
    }
    
    func setupCamera() {
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error: NSError?
        let input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        if error != nil && input == nil {
            let errorAlert = UIAlertView(title: "提醒", message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机", delegate: nil, cancelButtonTitle: "确定")
            errorAlert.show()
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        //可以看到的镜头区域
        layer?.frame = CGRect(x: (width-300)/2.0, y: 140, width: 300, height: 300)
        self.view.layer.insertSublayer(self.layer!, at: 0)
    
        let output = AVCaptureMetadataOutput()
        //设置响应区域
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
        }
        session.startRunning()
    
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        var stringValue: String?
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
            
            if stringValue != nil {
                self.session.stopRunning()
            }
            
        }
        self.session.stopRunning()
        
        let alertView = UIAlertView(title: "二维码", message: stringValue, delegate: self, cancelButtonTitle: "确定")
        alertView.show()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
