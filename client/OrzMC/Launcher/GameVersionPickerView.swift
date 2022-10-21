//
//  GameVersionPickerView.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct GameVersionPickerView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("游戏版本").bold()) {
                    /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                }
                .frame(maxWidth: 200)
                LauncherUIButton(title:"设置", imageSystemName: "gearshape")
            }.padding()
        }
    }
}

struct GameVersionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        GameVersionPickerView()
    }
}
