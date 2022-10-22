//
//  LauncherProgressView.swift
//  OrzMC
//
//  Created by joker on 2022/10/22.
//

import SwiftUI

struct LauncherProgressView: View {
    
    @EnvironmentObject private var appModel: LauncherModel

    var body: some View {
        HStack {
            Text("游戏加载进度: \(Int(appModel.launcherProgress * 100))%")
            ProgressView(value: appModel.launcherProgress)
                .progressViewStyle(LauncherProgressViewStyle())
        }
    }
}

struct LauncherProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(.yellow)
    }
}

struct LauncherProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherProgressView()
    }
}
