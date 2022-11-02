//
//  ViewController.swift
//  customLayout
//
//  Created by 김경환 on 2022/11/01.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tfSubmit: CommonTextField!
    @IBOutlet var tfAll: CommonTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfSubmit.onClickSubmitClosure = {
            self.alert(message: self.tfSubmit.text)
        }
        
        tfAll.onClickSubmitClosure = {
            self.alert(message: self.tfAll.text)
        }
    }
    
    public func alert(message: String, okHandler: (() -> ())? = nil) {
        let sheet = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(sheet, animated: true)
    }
}

