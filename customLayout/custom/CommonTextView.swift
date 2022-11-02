//
//  CommonTextView.swift
//  customLayout
//
//  Created by 김경환 on 2022/11/01.
//

import UIKit

@IBDesignable
class CommonTextView: UIView {
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var lbCount: UILabel!
    @IBOutlet private var btClear: UIButton!
    
    private let FOCUS_BORDER_COLOR: UIColor = .systemPink   // 포커스 될때 테두리 색상
    private let BORDER_COLOR: UIColor = #colorLiteral(red: 0.6,          green: 0.6, blue: 0.6, alpha: 1)                  // 기본 테두리 색상
    private let CORNER_RADIUS: CGFloat = 6                  // 테두리 둥근 정도
    private let BORDER_WIDTH: CGFloat = 1                   // 테두리 굵기
    private let PLACEHOLDER_TEXT_COLOR: UIColor = #colorLiteral(red: 0.6,          green: 0.6, blue: 0.6, alpha: 1)        // placeholder 텍스트 색상
    private let TEXT_VIEW_TEXT_COLOR: UIColor = #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1)          // textView 기본 색상
    
    @IBInspectable
    var text: String {
        get {
            return self.textView.text ?? ""
        }
        
        set {
            self.textView.text = newValue
        }
    }
    
    @IBInspectable
    var placeholder: String = "" {
        didSet {
            self.textView.text = placeholder
            self.textView.textColor = PLACEHOLDER_TEXT_COLOR
        }
    }
    
    @IBInspectable
    var textMaxCount: Int = 0 {
        didSet {
            
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
        let bundle = Bundle(for: CommonTextView.self)
        let identifier = String(describing: CommonTextView.self)
        let view = bundle.loadNibNamed(identifier, owner: self, options: nil)?.first as! UIView
        
        view.frame = bounds
        addSubview(view)
        
        initLayout()
    }
    
    private func initLayout() {
        self.textView.delegate = self
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.borderColor = BORDER_COLOR.cgColor
        self.layer.borderWidth = BORDER_WIDTH
        
        // textView 패딩 제거
        let padding = self.textView.textContainer.lineFragmentPadding
        self.textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        
        addDoneButtonOnKeyboard()
        
        if self.textMaxCount != 0 {
            self.lbCount.isHidden = false
            self.lbCount.text = "(0/\(textMaxCount))"
        } else {
            self.lbCount.isHidden = true
        }
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title:  NSLocalizedString("완료", comment: ""), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textView.inputAccessoryView = doneToolbar
    }
    
    private func onChnageTextCount() {
        guard
            let count = self.textView.text?.count
        else {
            return
        }
        
        if self.textMaxCount != 0 {
            self.lbCount.text = "(\(count)/\(textMaxCount))"
            
            if count > textMaxCount {
                self.textView.deleteBackward()
                return
            }
        }
        
        self.btClear.isHidden = self.textView.text == ""
    }

    @IBAction func onClickClear(_ sender: UIButton) {
        self.textView.text = ""
        
        self.onChnageTextCount()
    }
    
    @objc func doneButtonAction(){
        self.textView.resignFirstResponder()
    }
}

extension CommonTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.onChnageTextCount()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // placeholder
        if textView.text == self.placeholder {
            textView.text = ""
            textView.textColor = TEXT_VIEW_TEXT_COLOR
        }
        
        if self.textMaxCount != 0 {
            self.lbCount.isHidden = false
        }
        
        // borderColor
        textView.layer.borderColor = FOCUS_BORDER_COLOR.cgColor
        
        if let scroll = Util.getSuperView(currentView: self, targetView: UIScrollView().self) {
            scroll.setContentOffset(CGPoint(x: 0, y: (self.superview!.frame.origin.y)), animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // placeholder
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = self.placeholder
            textView.textColor = PLACEHOLDER_TEXT_COLOR
        }
        
        self.lbCount.isHidden = true
        
        // borderColor
        textView.layer.borderColor = BORDER_COLOR.cgColor
        
        if let scroll = Util.getSuperView(currentView: self, targetView: UIScrollView().self) {
            scroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}
