//
//  LauncherUserLoginArea.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct LauncherUserLoginArea: View {
    
    @Binding var username: String
    
    var loginAction: LauncherUIButtonAction?
    
    var body: some View {
        HStack {
            HStack {
                Text("玩家ID")
                TextField("输入游戏用户名", text: $username)
                    .frame(maxWidth: 150)
            }
            LauncherUIButton(title:"启动客户端", action: loginAction)
        }
        .bold()
        .padding()
    }
}

#Preview("未输入用户名") {
    LauncherUserLoginArea(username: .constant(""))
}

#Preview("用户名为: joker") {
    LauncherUserLoginArea(username: .constant("joker"))
}
