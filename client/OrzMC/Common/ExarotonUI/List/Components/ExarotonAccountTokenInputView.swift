//
//  ExarotonAccountTokenInputView.swift
//  OrzMC
//
//  Created by joker on 2024/5/21.
//

import SwiftUI

struct ExarotonAccountTokenInputView: View {
    @Binding var token: String
    var body: some View {
        VStack(alignment: .trailing, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Input Account Token: ")
                    .font(.title)
                    .bold()
                TextField("TOKEN", text: $token, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .lineLimit(nil)
#if os(macOS)
                    .frame(maxWidth: 400)
#endif
            }
            ExarotonTradeMarkView()
        }
        .padding(10)
    }
}

#Preview {
    ExarotonAccountTokenInputView(token: .constant("your_account_token"))
}
