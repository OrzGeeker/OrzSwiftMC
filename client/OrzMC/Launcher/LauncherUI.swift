//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {
    var body: some View {
        LauncherUIBackground()
            .overlay(Rectangle().foregroundColor(.black).blur(radius: 5).opacity(0.2))
            .overlay(GameVersionPickerView(), alignment: .bottomLeading)
            .overlay(LauncherUIButton(title:"关闭", imageSystemName: "power.circle") {
                exit(0)
            }.padding(), alignment: .topTrailing)
            .overlay(UserLoginArea(), alignment: .topLeading)
    }
}

struct LauncherUI_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUI()
            .frame(width: 3840.0/3.0, height: 1712.0/3.0)
    }
}
