//
//  SettingsView.swift
//  OrzMC
//
//  Created by joker on 2023/3/26.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
    var body: some View {
        VStack {
            ForEach(appModel.externalLinks, id: \.title) { linkInfo in
                Link(linkInfo.title, destination: linkInfo.link)
                    .bold()
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LauncherModel.mockModel)
    }
}
