//
//  LauncherUserLoginArea.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct LauncherUserLoginArea: View {
    
    @Binding var username: String
    
    var disableLoginButton: Bool = false
    
    var loginAction: LauncherUIButtonAction?
    
    var body: some View {
        HStack {
            HStack {
                Text("玩家ID")
                    .bold()
                TextField("输入游戏用户名", text: $username)
                    .bold()
                    .frame(maxWidth: 150)
                    .disabled(disableLoginButton)
            }
            LauncherUIButton(title:"登录", imageSystemName: "person.circle", action: loginAction)
                .disabled(disableLoginButton)
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
