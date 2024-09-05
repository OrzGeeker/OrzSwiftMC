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
            FeedBackButton(email: email)
                .buttonStyle(.borderless)
                .foregroundStyle(.yellow)
                .offset(x: offset.x, y: offset.y)
                .keyboardShortcut(.init(.init("f")), modifiers: .command)
        }
    }
}
