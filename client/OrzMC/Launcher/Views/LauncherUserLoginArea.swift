//
//  LauncherUserLoginArea.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct LauncherUserLoginArea: View {
    @EnvironmentObject private var appModel: LauncherModel
    @State var showAlert: Bool = false
    var body: some View {
        HStack {
            HStack {
                Text("玩家ID")
                TextField("输入游戏用户名", text: $appModel.username)
                    .frame(maxWidth: 120)
            }
            LauncherUIButton(title:"登录") {
                Task {
                    try await appModel.launch()
                }
            }
        }
        .padding()
    }
}

struct UserLoginArea_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUserLoginArea()
    }
}
