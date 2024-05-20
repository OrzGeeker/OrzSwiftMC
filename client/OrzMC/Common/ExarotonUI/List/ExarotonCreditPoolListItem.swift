//
//  ExarotonCreditPoolListItem.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import SwiftUI

struct ExarotonCreditPoolListItem: View {
    let creditPool: ExarotonCreditPool
    var body: some View {
        VStack(alignment: .leading) {
            if let name = creditPool.name {
                Text(name)
                    .font(.headline)
            }
            if let credits = creditPool.credits {
                HStack {
                    
                    Text("\(creditPool.members ?? 0) members")
                    
                    Text("\(creditPool.servers ?? 0) servers")
                    
                    Spacer()
                    
                    ExarotonCreditView(credits: credits)
                        .frame(height: 20)
                }
            }
        }
    }
}
