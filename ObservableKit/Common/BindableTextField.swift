//
//  BindableTextField.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 12.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import UIKit

class BindableTextField: UITextField {
    
    // MARK: Binding
    
    var bindableText = Observable<String>()
    
    private func setBindableText(text: String?) {
        if bindableText.value != text {
            bindableText <- text
        }
    }
    
    override var text: String? {
        didSet {
            setBindableText(text)
        }
    }
    
    private func setupInternalBindings() {
        // Synchronize our bindableText property with our text property
        bindableText += Listener(self) { [unowned self] oldVal, newVal in
            if self.text != newVal {
                self.text = newVal
            }
        }
    }
    
    // MARK: UITextFieldDelegate relay
    
    weak var delegateRelay: UITextFieldDelegate?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        setupInternalBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        setupInternalBindings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setupInternalBindings()
    }
}

extension BindableTextField: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        setBindableText(textField.text)
        if let del = delegateRelay where del.respondsToSelector(Selector("textFieldShouldEndEditing:")) {
            return del.textFieldShouldEndEditing!(textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        setBindableText(textField.text)
        delegateRelay?.textFieldDidEndEditing?(textField)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var shouldChange = true
        if let del = delegateRelay where del.respondsToSelector(Selector("textField:shouldChangeCharactersInRange:replacementString:")) {
            shouldChange = del.textField!(textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
        
        if shouldChange {
            let changedText = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)
            if let string = changedText {
                textField.text = string as String?
                shouldChange = false
            }
        }
        return shouldChange
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        setBindableText(textField.text)
        if let del = delegateRelay where del.respondsToSelector(Selector("textFieldShouldClear:")) {
            return del.textFieldShouldClear!(textField)
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        setBindableText(textField.text)
        if let del = delegateRelay where del.respondsToSelector(Selector("textFieldShouldReturn:")) {
            return del.textFieldShouldReturn!(textField)
        }
        return true
    }
}