//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
    var body: some View {
        LauncherUIBackground()
            .overlay {
                Rectangle()
                    .foregroundColor(.black)
                    .blur(radius: 10)
                    .opacity(0.2)
            }
            .overlay(alignment: .topTrailing) {
                LauncherUIButton(title:"关闭", imageSystemName: "power.circle") {
                    exit(0)
                }
                .padding()
            }
            .overlay(alignment: .topLeading) {
                LauncherUserLoginArea()
            }
            .overlay(alignment: .bottomLeading) {
                LauncherGameVersionPickerView()
            }
            .frame(width: appModel.windowSize.width, height: appModel.windowSize.height)
    }
}

struct LauncherUI_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUI()
    }
}

