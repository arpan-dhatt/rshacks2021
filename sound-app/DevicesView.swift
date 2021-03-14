//
//  DevicesView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct DevicesView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                HStack{
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Text("New Sound")
                            Image(systemName: "mic.circle").resizable().frame(width: 30, height: 30)
                        }.padding(7.5).background(Color.black).cornerRadius(25.0).foregroundColor(.white)
                    })
                }
            }.navigationBarTitle("Activity").navigationBarItems(trailing: Button(action: {
                // will show and let you copy group id
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 30).foregroundColor(.black)
            }))
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
