//
//  ExarotonCreditPoolListLinkItem.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import SwiftUI

struct ExarotonCreditPoolListLinkItem: View {
    @Environment(ExarotonServerModel.self) var model
    let creditPool: ExarotonCreditPool
    var body: some View {
        NavigationLink {
            ExarotonCreditPoolDetail(creditPool: creditPool)
                .environment(model)
        } label: {
            ExarotonCreditPoolListItem(creditPool: creditPool)
        }
    }
}
