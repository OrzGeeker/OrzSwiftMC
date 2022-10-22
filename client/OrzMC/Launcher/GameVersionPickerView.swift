//
//  GameVersionPickerView.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct GameVersionPickerView: View {
    
    @EnvironmentObject var appModel: LauncherModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                if !appModel.versions.isEmpty {
                    Picker(selection: $appModel.selectedVersion, label: Text("游戏版本").bold()) {
                        ForEach(appModel.versions, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    .frame(maxWidth: 200)
                }
                LauncherUIButton(title:"设置", imageSystemName: "gearshape")
            }.padding()
        }
    }
}

struct GameVersionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        GameVersionPickerView()
            .environmentObject(mockAppModel)
    }
}
