//
//  ActivityView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct ActivityView: View {
    var allCategories = [["one", "person.crop.circle.badge.plus"],["two", "person.crop.circle.badge.plus"],["one", "person.crop.circle.badge.plus"],["one", "person.crop.circle.badge.plus"]]
    let allPurposes = ["All", "Security","SmartHome","Hobby","Children","Other"]
    var currentQuery = activity_Query.init(group_id: "4353j4lk5j34lkj5lk34j5", device_id: nil, category: nil)
    
    var body: some View {
        NavigationView {
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(allCategories, id: \.self){card in
                            CategoryCard(categoryName: card[0], categorySymbol: card[1])
                        }
                    }
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
                SoundListView(query: currentQuery)
            

            }.navigationBarTitle("Activity").navigationBarItems(trailing: Button(action: {
                // will show and let you copy group id
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 30).foregroundColor(.black)
            }))
        }
    }
}

struct CategoryCard: View {
    var categoryName:String
    var categorySymbol:String
    var body: some View {
        VStack{
            HStack{
                TitleViewLight(input: categoryName)
                Spacer()
                Image(systemName: categorySymbol).font(.title)
            }
            Spacer()
        }.padding().frame(width: 300, height: 150, alignment: .leading).background(Color.white).cornerRadius(10.0).shadow(radius: 10.0).padding()
    }
}
struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
