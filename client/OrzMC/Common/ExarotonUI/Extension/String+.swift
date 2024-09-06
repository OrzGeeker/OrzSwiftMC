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
    @discardableResult
    @MainActor func copyToPasteboard() -> Bool {
#if canImport(UIKit)
        UIPasteboard.general.string = self
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        return true
#endif

#if canImport(AppKit)
        NSPasteboard.general.declareTypes([.string], owner: nil)
        let success = NSPasteboard.general.setString(self, forType: .string)
        return success
#endif
    }
}
