//
//  CustomTextField.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/06.
//

import Foundation
import SwiftUI

struct NoMenuTextField: UIViewRepresentable {
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UITextField {
        let textField = NoMenuUITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.borderStyle = .roundedRect
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged), for: .editingChanged)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NoMenuTextField
        
        init(_ parent: NoMenuTextField) {
            self.parent = parent
        }
        
        @objc func textChanged(_ sender: UITextField) {
            parent.text = sender.text ?? ""
        }
    }
}

class NoMenuUITextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .right // ← 右詰めを追加
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.textAlignment = .right // ← nib経由でも右詰め
    }
    
    // コピー、ペースト、選択などすべてのメニューを無効化
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
