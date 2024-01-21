//
//  SettingsView.swift
//  OrzMC
//
//  Created by joker on 2023/3/26.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(LauncherModel.self) private var appModel
    
    var body: some View {
        Text("Settings")
    }
}

#Preview {
    SettingsView()
        .environment(LauncherModel())
}
