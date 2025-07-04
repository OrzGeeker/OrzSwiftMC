//
//  ExarotonContent.swift
//  OrzMC
//
//  Created by joker on 2024/5/22.
//

import SwiftUI

struct ExarotonContent: View {
    @State private var model = ExarotonServerModel()
    var body: some View {
        NavigationStack(path: $model.path) {
            ExarotonServerList().environment(model)
        }
    }
}

#Preview {
    ExarotonContent()
}
