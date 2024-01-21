//
//  LauncherTerminateButton.swift
//  OrzMC
//
//  Created by joker on 2023/3/26.
//

import SwiftUI

struct LauncherTerminateButton: View {
    var body: some View {
        LauncherUIButton(
            title:"关闭",
            imageSystemName: "power.circle") {
                exit(0)
            }
            .padding()
    }
}

#Preview {
    LauncherTerminateButton()
}
