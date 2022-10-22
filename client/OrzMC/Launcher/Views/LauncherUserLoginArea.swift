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
        VStack(alignment: .leading) {
            LauncherUIButton(title:"登录") {
                Task {
                    try await appModel.launch()
                }
            }
            HStack {
                Text("玩家ID")
                TextField("请输入一个用户名作为游戏ID", text: $appModel.username)
                    .frame(maxWidth: 200)
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
