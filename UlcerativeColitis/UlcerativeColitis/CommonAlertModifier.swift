//
//  CommonAlertModifier.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/08.
//

import SwiftUI

struct CommonAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
//    let done: String
    let confirmAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("キャンセル", role: .cancel) {}
                Button("削除", role: .destructive, action: confirmAction)
            } message: {
                Text(message)
            }
    }
}

extension View {
    func commonAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmAction: @escaping () -> Void
    ) -> some View {
        modifier(CommonAlertModifier(isPresented: isPresented, title: title, message: message, confirmAction: confirmAction))
    }
}

//#Preview {
//    CommonAlertModifier()
//}
