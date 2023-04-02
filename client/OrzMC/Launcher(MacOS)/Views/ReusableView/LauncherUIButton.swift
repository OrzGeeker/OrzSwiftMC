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
            .padding(.vertical)
        })
    }
}

struct LauncherUIButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LauncherUIButton(title:"登录")
                .previewDisplayName("仅标题")
            LauncherUIButton(imageSystemName: "gearshape")
                .previewDisplayName("仅图标")
            LauncherUIButton(title:"关闭", imageSystemName: "power.circle")
                .previewDisplayName("图标+标题")
        }
    }
}
