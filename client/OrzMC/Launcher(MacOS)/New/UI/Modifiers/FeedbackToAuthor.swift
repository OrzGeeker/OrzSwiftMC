//
//  FeedbackToAuthor.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI
import SwiftUIX

extension View {
    func feedbackToAuthor(
        email: String,
        overlayAlignment: Alignment = .bottomTrailing,
        offset: CGPoint = .init(x: -10, y: -10)
    ) -> some View {
        return self.modifier(
            FeedbackToAuthor(
                email: email,
                overlayAlignment: overlayAlignment,
                offset: offset
            )
        )
    }
}

struct FeedbackToAuthor: ViewModifier {
    let email: String
    let overlayAlignment: Alignment
    let offset: CGPoint
    func body(content: Content) -> some View {
        content
            .overlay(alignment: overlayAlignment) {
                FeedBackButton(email: email)
                    .offset(x: offset.x, y: offset.y)
                    .foregroundStyle(.yellow)
                    .keyboardShortcut(.init(.init("f")), modifiers: .command)
            }
    }
}
