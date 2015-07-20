//
//  BindableTextField.swift
//  ObservableKit-iOS
//
//  Created by Florian Rath on 12.07.15.
//  Copyright © 2015 Codepool GmbH. All rights reserved.
//

import UIKit

public class BindableTextField: UITextField {
    
    // MARK: Binding
    
    public var bindableText = Observable<String>()
    
    private func setBindableText(text: String?) {
        if bindableText.value != text {
            bindableText <- text
        }
    }
    
    override public var text: String? {
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
    
    public weak var delegateRelay: UITextFieldDelegate?
    
    // MARK: Lifecycle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        setupInternalBindings()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        setupInternalBindings()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setupInternalBindings()
    }
}

extension BindableTextField: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        setBindableText(textField.text)
        if let del = delegateRelay where del.respondsToSelector(Selector("textFieldShouldEndEditing:")) {
            return del.textFieldShouldEndEditing!(textField)
        }
        return true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        setBindableText(textField.text)
        delegateRelay?.textFieldDidEndEditing?(textField)
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
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
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        setBindableText(textField.text)
        if let del = delegateRelay where del.respondsToSelector(Selector("textFieldShouldClear:")) {
            return del.textFieldShouldClear!(textField)
        }
        return true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        setBindableText(textField.text)
        if let del = delegateRelay where del.respondsToSelector(Selector("textFieldShouldReturn:")) {
            return del.textFieldShouldReturn!(textField)
        }
        return true
    }
}