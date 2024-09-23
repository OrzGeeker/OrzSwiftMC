//
//  ExarotonContent.swift
//  OrzMC
//
//  Created by joker on 2024/5/22.
//

import SwiftUI

struct ExarotonContent: View {
    @AppStorage(ExarotonServerModel.accountTokenPersistentKey) var token: String = ""
    @State private var model = ExarotonServerModel()
    var body: some View {
        NavigationStack(path: $model.path) {
            ExarotonServerList(token: token).environment(model)
        }
    }
}

#Preview {
    ExarotonContent()
}
