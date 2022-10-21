//
//  UserLoginArea.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct UserLoginArea: View {
    @State private var username: String = "joker"
    var body: some View {
        VStack(alignment: .leading) {
            LauncherUIButton(title:"登录")
            HStack {
                Text("用户名")
                TextField("请输入一个用户名作为游戏ID", text: $username)
                    .frame(maxWidth: 200)
            }
        }.padding()
    }
}

struct UserLoginArea_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginArea()
    }
}
