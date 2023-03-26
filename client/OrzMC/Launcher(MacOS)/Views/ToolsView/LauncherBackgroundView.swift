//
//  LauncherBackgroundView.swift
//  OrzMC
//
//  Created by joker on 2023/3/26.
//

import SwiftUI

struct LauncherBackgroundView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .blur(radius: 10)
            .opacity(0.2)
            .background(Image("LauncherBG")
                .resizable()
                .aspectRatio(contentMode: .fill))
    }
}

struct LauncherBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        LauncherBackgroundView()
            .previewLayout(.fixed(width: 3840 / 3.0, height: 1712 / 3.0))
    }
}
