//
//  ActivityView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct ActivityView: View {
    var allCategories = [["one", "person.crop.circle.badge.plus"],["two", "person.crop.circle.badge.plus"],["one", "person.crop.circle.badge.plus"],["one", "person.crop.circle.badge.plus"]]
    let allPurposes = ["All","SmartHome","Security","Hobby","Children","Other"]
    @State var showingInfoSheet = false
    @StateObject var dataSource = SoundListDataSource()
    @StateObject var deviceDataSource = DeviceListDataSource()
    
    @AppStorage("group_id") var group_id = "NONE"
    
    var body: some View {
        NavigationView {
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(allPurposes, id: \.self){card in
                            CategoryCard(categoryName: card, categorySymbol: PurposeIcon.getIcon[card]!,alertsReceived: dataSource.alertsForCategory(category: card), devicesActive: deviceDataSource.devicesForCategory(category: card), backgroundColor: PurposeColors.getColor[card]!)
                        }
                    }.onAppear(perform: {
                        dataSource.loadFake(query: activity_Query(group_id: group_id, device_id: nil, category: nil))
                        deviceDataSource.loadFake(query: devices_Query(group_id: group_id))
                    })
                }
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(allPurposes, id: \.self) { purpose in
                            Text(purpose).frame(minWidth: 100).padding().background(Color.black).cornerRadius(25.0).shadow(radius: 10.0).foregroundColor(.white)
                        }
                    }.padding()
                }
                HStack{
                    TitleViewBold(input: "Recent Activity:")
                    Spacer()
                }.padding(.horizontal)
                SoundListView(query: activity_Query(group_id: group_id, device_id: nil, category: nil))
            

            }.navigationBarTitle("Activity").navigationBarItems(trailing: Button(action: {
                withAnimation{
                    showingInfoSheet.toggle()
                }
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 34).foregroundColor(.black)
            })).sheet(isPresented: $showingInfoSheet, content: {
                GroupInfoModal()
            })
        }
    }
}

struct CategoryCard: View {
    var categoryName:String
    var categorySymbol:String
    var alertsReceived:Int
    var devicesActive:Int
    var backgroundColor:LinearGradient
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                TitleViewLight(input: categoryName)
                Spacer()
                Image(systemName: categorySymbol).font(.title)
            }.padding(.bottom)
            ParagraphView(input: "Amount Of Alerts Received: \(alertsReceived)")
            ParagraphView(input: "Amount Of Devices Active: \(devicesActive)")
            Spacer()
        }.padding().frame(width: 300, height: 150, alignment: .leading).background(backgroundColor).cornerRadius(10.0).shadow(radius: 10.0).padding().foregroundColor(.white)
    }
}
struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
