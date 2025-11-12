//
//  CustomHStackView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/11/12.
//

import SwiftUI

struct CustomHStackView<TextView: View, IntView: View>: View {
    
    let textView: () -> TextView
    let intView: () -> IntView
    
    var body: some View {
        HStack(alignment: .bottom) {
            textView()
                .foregroundColor(.black)
                .font(.system(size: 15))
                .padding(.bottom, 10)
            intView()
                .foregroundColor(.black)
                .font(.system(size: 30))
        }
    }
}

//#Preview {
//    CustomHStackView()
//}
