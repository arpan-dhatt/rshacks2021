//
//  BrowseView.swift
//  sound-app
//
//  Created by Arpan Dhatt on 3/13/21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
            VStack {
                TextField("Search...", text: $text).padding(10).padding(.horizontal, 25).background(Color("GrayTop")).cornerRadius(10).onTapGesture{
                    self.isEditing = true
                }.overlay(
                    HStack{
                        Image(systemName: "magnifyingglass").foregroundColor(.white).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }, label: {
                                Image(systemName: "multiply.circle.fill").foregroundColor(.white).padding(.trailing, 10)
                            })
                        }
                    }
                ).foregroundColor(.white)
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Text("Cancel").padding().background(Color("GreenBottom")).cornerRadius(10.0).foregroundColor(.white)
                    }).padding(.trailing, 10).transition(.move(edge: .trailing)).animation(.default)
                }
                
            }
    }
}

struct BrowseView: View {
    var allItems = [AvailibleSound.init(name: "Glass", category: "Security", description: "Right now, houses require dozens of glas break sensors to work, replace them with just one sensor"),AvailibleSound.init(name: "Garage", category: "Other", description: "Want to know when your housemates arrive, this add-on allows you to keep tabs on the house"),AvailibleSound.init(name: "Knock", category: "SmartHome", description: "Someone knocks on the door, but you didn't here, this add-on notifies you whenever somone is at the door"),AvailibleSound.init(name: "Child", category: "Children", description: "Child or baby in the other room, want some alone time, use this add-on to gain some freedom")]
    @State var searchText = ""
    @State var showingInfoSheet = false
    
    var body: some View{
        NavigationView{
            VStack{
                SearchBar(text: $searchText).padding()
                ScrollView{
                    ForEach(allItems.filter({searchText.isEmpty ? true: $0.name.contains(searchText)}), id: \.self){item in
                    BrowseCardView(item: item)
                    }.foregroundColor(.black)
                }
            }.navigationBarTitle("Browse").navigationBarItems(trailing: Button(action: {
                showingInfoSheet.toggle()
            }, label: {
                Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width: 40, height: 34).foregroundColor(.black)
            })).sheet(isPresented: $showingInfoSheet, content: {
                GroupInfoModal()
            })
        }
    }
}

struct BrowseCardView: View {
    var item: AvailibleSound
    
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Image(systemName: PurposeIcon.getIcon[item.category] ?? "flame.fill").font(.title)
                Spacer()
                Image(systemName: "ellipsis.circle.fill").font(.title)
            }
            HStack(alignment: .top){
                HStack{
                VStack(alignment: .leading){
                    TitleViewBold(input: item.name)
                    SubtitleViewLight(input: item.category)
                    Button(action: {
                        withAnimation{
                            
                        }
                    }, label: {
                        HStack{
                            Text("Add")
                            Image(systemName: "plus").font(.title2)
                        }.padding().background(Color.white).foregroundColor(.black).cornerRadius(10.0)
                    })
                }
                    Spacer()
                }.frame(width: 150).padding(.trailing)
                
                VStack(alignment:.leading){
                    ParagraphViewBold(input: "Description:")
                    Text(item.description).font(.caption)
                }
            }
            
        }.padding().frame(height: 200).background(PurposeColors.getColor[item.category]).cornerRadius(10.0).padding(.horizontal).padding(.vertical, 10).shadow(radius: 10).foregroundColor(.white)
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
