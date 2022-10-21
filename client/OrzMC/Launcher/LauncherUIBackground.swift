//
//  LauncherUIBackground.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct LauncherUIBackground: View {
    var body: some View {
        Image("LauncherBG")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct LauncherUIBackground_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUIBackground()
            .frame(width: 3840.0/3.0, height: 1712.0/3.0)
    }
}
