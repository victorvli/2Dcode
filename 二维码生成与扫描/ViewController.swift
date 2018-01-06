//
//  ViewController.swift
//  二维码生成与扫描
//
//  Created by ljk on 17/10/29.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var textF: UITextField!
    
    @IBOutlet weak var imgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    //二维码生成
    @IBAction func createBtnClick(_ sender: UIButton) {
    
        self.imgV.image = self.textF.text?.generateQRCode(size: 400, color: UIColor.red, bgColor: UIColor.white, logo: UIImage(named: "2.jpg"))
        
    }
    //二维码扫描
    @IBAction func scanBtnClick(_ sender: UIButton) {
        let vc = QRCodeVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func recognizeQRCode(_ sender: UIButton) {
        
        let str = self.imgV.image?.recognizeQRCode()
        
        print(str ?? "还未生成二维码")
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

