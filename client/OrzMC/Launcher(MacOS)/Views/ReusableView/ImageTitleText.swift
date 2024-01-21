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

#Preview("仅标题") {
    ImageTitleText(title:"登录")
        .padding()
}

#Preview("仅图标") {
    ImageTitleText(imageSystemName: "gearshape")
        .padding()
}

#Preview("图标+标题") {
    ImageTitleText(title:"关闭", imageSystemName: "power.circle")
        .padding()
}
