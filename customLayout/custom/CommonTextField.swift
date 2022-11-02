//
//  CommonTextField.swift
//  customLayout
//
//  Created by 김경환 on 2022/11/01.
//

import UIKit

@IBDesignable
class CommonTextField: UIView {
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var lbCount: UILabel!
    @IBOutlet private var btClear: UIButton!
    @IBOutlet private var btSubmit: UIButton!
    
    private let FOCUS_BORDER_COLOR: UIColor = .systemPink   // 포커스 될때 테두리 색상
    private let BORDER_COLOR: UIColor = #colorLiteral(red: 0.6,          green: 0.6, blue: 0.6, alpha: 1)                  // 기본 테두리 색상
    private let CORNER_RADIUS: CGFloat = 6                  // 테두리 둥근 정도
    private let BORDER_WIDTH: CGFloat = 1                   // 테두리 굵기
    private let PLACEHOLDER_TEXT_COLOR: UIColor = #colorLiteral(red: 0.6642269492, green: 0.6642268896, blue: 0.6642268896, alpha: 1)        // placeholder 글자 색상
    
    public var shouldReturnClosure: (() -> ())?
    public var onClickSubmitClosure: (() -> ())?
    
    @IBInspectable
    var placeholder: String? {
        get {
            return self.textField.placeholder
        }
        
        set {
            let placeholderAttributes = [NSAttributedString.Key.foregroundColor : PLACEHOLDER_TEXT_COLOR]
            self.textField.attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: placeholderAttributes)
        }
    }
    
    @IBInspectable
    var text: String {
        get {
            return self.textField.text ?? ""
        }
        
        set {
            self.textField.text = newValue
            
            self.onChnageTextCount()
        }
    }
    
    @IBInspectable
    var textMaxCount: Int = 0 {
        didSet {
            
        }
    }
    
    @IBInspectable
    var submitImage: UIImage? {
        get {
            return self.btSubmit.image(for: .normal)
        }
        
        set {
            if let newValue = newValue {
                self.btSubmit.isHidden = false
                self.btSubmit.setImage(newValue, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXib()
    }
    
    private func loadXib() {
        let bundle = Bundle(for: CommonTextField.self)
        let identifier = String(describing: CommonTextField.self)
        let view = bundle.loadNibNamed(identifier, owner: self, options: nil)?.first as! UIView
        
        view.frame = bounds
        addSubview(view)
        
        initLayout()
    }
    
    private func initLayout() {
        self.textField.delegate = self
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.borderColor = BORDER_COLOR.cgColor
        self.layer.borderWidth = BORDER_WIDTH
        
        addDoneButtonOnKeyboard()
        
        if self.textMaxCount != 0 {
            self.lbCount.isHidden = false
            self.lbCount.text = "(0/\(textMaxCount))"
        } else {
            self.lbCount.isHidden = true
        }
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title:  NSLocalizedString("딛기", comment: ""), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textField.inputAccessoryView = doneToolbar
    }
    
    private func onChnageTextCount() {
        guard
            let count = self.textField.text?.count
        else {
            return
        }
        
        if self.textMaxCount != 0 {
            self.lbCount.text = "(\(count)/\(textMaxCount))"
            
            if count > textMaxCount {
                self.textField.deleteBackward()
                return
            }
        }
        
        self.btClear.isHidden = self.textField.text == ""
    }
    
    @objc func doneButtonAction() {
        self.textField.resignFirstResponder()
    }
    
    @IBAction func textFeldEditingChanged(_ sender: UITextField) {
        self.onChnageTextCount()
    }
    
    @IBAction func onClickClear(_ sender: UIButton) {
        self.textField.text = ""
        
        self.onChnageTextCount()
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        self.onClickSubmitClosure?()
    }
}

extension CommonTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.layer.borderColor = FOCUS_BORDER_COLOR.cgColor
        
        if self.textMaxCount != 0 {
            self.lbCount.isHidden = false
        }
        
        if let scroll = Util.getSuperView(currentView: self, targetView: UIScrollView().self) {
            scroll.setContentOffset(CGPoint(x: 0, y: (self.superview!.frame.origin.y)), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = BORDER_COLOR.cgColor
        
        self.lbCount.isHidden = true
        
        if let scroll = Util.getSuperView(currentView: self, targetView: UIScrollView().self) {
            scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.shouldReturnClosure?()
        
        return true
    }
}
