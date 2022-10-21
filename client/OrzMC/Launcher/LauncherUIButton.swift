//
//  LauncherUIButton.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

typealias LauncherUIButtonAction = () -> Void

struct LauncherUIButton: View {
    
    var title: String? = nil
    
    var imageSystemName: String? = nil
    
    var action: LauncherUIButtonAction? = nil
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            }
        }, label: {
            if let imageSystemName = imageSystemName {
                Image(systemName: imageSystemName)
            }
            if let title = title {
                Text(title).bold()
            }
        })
    }
}

struct LauncherUIButton_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUIButton(title:"登录")
            .previewDisplayName("仅标题")
        LauncherUIButton(imageSystemName: "gearshape")
            .previewDisplayName("仅图标")
        LauncherUIButton(title:"关闭", imageSystemName: "power.circle")
            .previewDisplayName("图标+标题")
    }
}
