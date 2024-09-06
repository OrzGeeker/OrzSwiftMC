//
//  FeedbackToAuthor.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI
import SwiftUIX

extension View {
    func feedbackToAuthor(email: String,
                          overlayAlignment: Alignment = .bottomTrailing,
                          offset: CGPoint = .init(x: -10, y: -10)) -> some View {
        let customModifier = FeedbackToAuthor(email: email,
                                              overlayAlignment: overlayAlignment,
                                              offset: offset)
        return self.modifier(customModifier)
    }
}

struct FeedbackToAuthor: ViewModifier {
    let email: String
    let overlayAlignment: Alignment
    let offset: CGPoint
    func body(content: Content) -> some View {
        content.overlay(alignment: overlayAlignment) {
            HStack(spacing: 10) {
                
                FeedBackButton(email: email)
                    .buttonStyle(.borderless)
                    .foregroundStyle(.yellow)
                    .keyboardShortcut(.init(.init("f")), modifiers: .command)
                
                BuyMeCoffeeButton(
                    content:
                        Image("alipay")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200 * 0.5, height: 235 * 0.5)
                )
                .keyboardShortcut(.init(.init("p")), modifiers: .command)
                
            }
            .offset(x: offset.x, y: offset.y)
        }
    }
}
