//
//  ExarotonCreditView.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import SwiftUI
struct ExarotonCreditView: View {
    let credits: Double?
    var body: some View {
        let iconName = "bubbles.and.sparkles.fill"
        let credits = String(format: "%.2lf", credits ?? 0)
        ViewThatFits {
            VStack(alignment: .center) {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(.yellow)
                    .frame(width: 100, height: 100)
                Text(credits)
                    .font(.title)
                    .bold()
            }
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(.yellow)
                Text(credits)
            }
            .frame(height: 20)
        }
    }
}
