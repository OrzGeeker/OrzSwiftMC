//
//  ToolView.swift
//  OrzMC
//
//  Created by wangzhizhou on 2025/4/5.
//

import SwiftUI

struct ToolView: View {
    enum ToolItem: Int, Identifiable, CaseIterable {
        case exaroton
        case links
        var id: Int { self.rawValue }
    }
    @Binding var model: ExarotonServerModel
    var body: some View {
        ForEach(ToolItem.allCases) { item in
            switch item {
            case .exaroton:
                Button("Remote Server", systemImage: "gamecontroller") {
                    model.path.append(ToolItem.exaroton)
                }
                .keyboardShortcut(.init(.init("s")), modifiers: .command)
                .navigationDestination(for: ToolView.ToolItem.self, destination: handleTool)
            case .links:
                LinkMenu(path: $model.path)
            }
        }
    }
    
    @ViewBuilder
    func handleTool(_ tool: ToolItem) -> some View {
        switch tool {
        case .exaroton:
            ExarotonServerList()
                .environment(model)
        default:
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var model = ExarotonServerModel()
    ToolView(model: $model)
}
