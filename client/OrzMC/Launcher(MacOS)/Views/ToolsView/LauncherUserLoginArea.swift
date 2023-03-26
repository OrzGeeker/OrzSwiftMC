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
                .frame(maxWidth: 120)
            }
            LauncherUIButton(title:"登录", action: loginAction)
        }
        .padding()
    }
}

struct UserLoginArea_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LauncherUserLoginArea(username: .constant(""))
                .previewDisplayName("未输入用户名")
            LauncherUserLoginArea(username: .constant("joker"))
                .previewDisplayName("用户名为: joker")
        }
    }
}
