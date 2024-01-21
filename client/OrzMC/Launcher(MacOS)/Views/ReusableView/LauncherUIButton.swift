//
//  LauncherUIButton.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

typealias LauncherUIButtonAction = () -> Void

struct LauncherUIButton: View {
    
    var title: String?
    
    var imageSystemName: String?
    
    var action: LauncherUIButtonAction?
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            }
        }, label: {
            ImageTitleText(
                title: title,
                imageSystemName: imageSystemName)
        })
    }
}

#Preview("仅标题") {
    LauncherUIButton(title:"登录")
        .padding()
}

#Preview("仅图标") {
    LauncherUIButton(imageSystemName: "gearshape")
        .padding()
}

#Preview("图标+标题") {
    LauncherUIButton(title:"关闭", imageSystemName: "power.circle")
        .padding()
}
