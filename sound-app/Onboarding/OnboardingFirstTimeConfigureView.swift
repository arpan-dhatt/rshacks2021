//
//  OnboardingFirstTimeConfigureView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct OnboardingFirstTimeConfigureView: View {
    
    @State var showImagePicker = false
    @State var pickedImage: UIImage? = nil
    @Binding var currentOnboardingView: OnboardingViewEnum
    
    @State var deviceName = ""
    @State var deviceLocation = ""
    @State var devicePurposeUser: devicePurpose = .smartHome
    
    var body: some View {
        ScrollView{
            Text("Sound Shot").font(.title2).fontWeight(.light).italic().padding()
            TitleViewBold(input: "Configure Your New SoundShot").multilineTextAlignment(.center)
            
            VStack{
                HStack{
                    SubtitleViewLight(input: "Image Of Device")
                    Spacer()
                    Image(systemName: "photo.fill").font(.title)
                }.padding([.top,.leading, .trailing])
                
                if pickedImage != nil {
                    Image(uiImage: pickedImage!).resizable().scaledToFill().cornerRadius(10.0).padding()
                    
                }
                Button(action: {self.showImagePicker.toggle()}, label: {
                    HStack{
                        Spacer()
                        Text("Pick Image").font(.title2)
                        Image(systemName: "plus").font(.title2)
                        Spacer()
                    }.padding().background(Color(.blue)).foregroundColor(.white).cornerRadius(50).padding()
                })
            }.padding().background(Color.white).cornerRadius(10.0).shadow(radius: 5.0, x:25, y:25).shadow(radius: 2.5).padding()
            
            VStack{
                SubtitleViewLight(input: "Name Of Device")
                TextField("name", text: $deviceName).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding().padding(.horizontal, 20)
                SubtitleViewLight(input: "Location Of Device")
                TextField("e.g. outside", text: $deviceLocation).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding().padding(.horizontal, 20)
                SubtitleViewLight(input: "Purpose Of Device")
            
                Picker(selection: $devicePurposeUser, label:HStack{
                        Spacer()
                    ParagraphView(input: devicePurposeUser.rawValue.uppercased()).padding()
                    Image(systemName: "square.and.pencil")
                        Spacer()
                }.overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding().padding(.horizontal)){
                    ForEach(devicePurpose.allCases){
                            Text($0.rawValue).font(.title2).textCase(.uppercase)
                        }
                    }.pickerStyle(MenuPickerStyle())
                
            }.padding(.vertical).foregroundColor(.black)
            
            Button(action: {
                withAnimation{
                    currentOnboardingView = .firstTime
                }
            }, label: {
                HStack{
                    SubtitleView(input: "Complete")
                    Image(systemName: "arrow.right").font(.title)
                }.padding(25).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding().transition(.slide)
            
            
        }.sheet(isPresented: $showImagePicker, onDismiss: {self.showImagePicker = false}, content: {
            ImagePicker(image: $pickedImage, isShown: $showImagePicker)
        })
    }
}

struct OnboardingFirstTimeConfigureView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirstTimeConfigureView(currentOnboardingView: .constant(.fistTimeConfigure))
    }
}

enum devicePurpose: String, CaseIterable, Identifiable {
    case security = "Security"
    case smartHome = "SmartHome"
    case hobby = "Hobby"
    case other = "Other"
    case children = "Children"
    
    var id: String { self.rawValue }
}



