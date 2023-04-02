//
//  ImageTitleText.swift
//  OrzMC
//
//  Created by joker on 2023/4/2.
//

import SwiftUI

struct ImageTitleText: View {
    
    var title: String?
    
    var imageSystemName: String?
    
    var body: some View {
        HStack {
            if let imageSystemName = imageSystemName {
                Image(systemName: imageSystemName)
            }
            if let title = title {
                Text(title).bold()
            }
        }
    }
}

struct ImageTitleText_Previews: PreviewProvider {
    static var previews: some View {
        ImageTitleText(title:"登录")
            .previewDisplayName("仅标题")
        ImageTitleText(imageSystemName: "gearshape")
            .previewDisplayName("仅图标")
        ImageTitleText(title:"关闭", imageSystemName: "power.circle")
            .previewDisplayName("图标+标题")
    }
}
