//
//  ExarotonCopyableText.swift
//  OrzMC
//
//  Created by joker on 9/6/24.
//

import SwiftUI

struct ExarotonCopyableText: View {
    
    private let content: String
    private let canCopy: Bool
    
    @State private var copyed: Bool = false
    @State private var isTapped: Bool = false
    
    init(_ content: String, canCopy: Bool = false) {
        self.content = content
        self.canCopy = canCopy
    }
    
    var labelTitle: String {
        copyed ? "copyed" : "copy it"
    }
    
    var labelIcon: String {
        copyed ? "list.bullet.clipboard" : "clipboard"
    }
    
    var body: some View {
        HStack {
            Text("\(content)")
            
            Spacer()
            
            if canCopy {
                Image(systemName: isTapped ? "checkmark.circle" : "document.on.clipboard")
                    .bold()
                    .contentTransition(.symbolEffect(.replace))
                    .foregroundStyle(copyed ? .green : .blue)
                    .onTapGesture {
                        isTapped = true
                        copyed = content.copyToPasteboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isTapped = false
                            copyed = false
                        }
                    }
            }
        }
    }
}

#Preview {
    ExarotonCopyableText("Content To Be Copyed!")
}
