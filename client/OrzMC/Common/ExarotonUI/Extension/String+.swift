//
//  String+.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

extension String {
    func copyToPasteboard() {
#if canImport(UIKit)
        UIPasteboard.general.string = self
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
#endif

#if canImport(AppKit)
        NSPasteboard.general.setString(self, forType: .string)
#endif
    }
}
