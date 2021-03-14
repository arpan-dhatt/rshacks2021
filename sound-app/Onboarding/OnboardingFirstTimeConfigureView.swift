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
        VStack{
            TitleViewBold(input: "Configure Your New SoundShot").multilineTextAlignment(.center).padding(.bottom)
            
            HStack{
                Image(systemName: "gear").font(.system(size: 100)).offset(x: 40, y: 20).rotationEffect(.degrees(35))
                Image(systemName: "gear").font(.system(size: 100)).offset(x: -40, y: -20)
                
            }
            
            VStack{
                SubtitleViewLight(input: "Name Of Device").padding(.top, 35)
                TextField("name", text: $deviceName).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding(.horizontal, 30)
                SubtitleViewLight(input: "Location Of Device").padding(.top)
                TextField("e.g. outside", text: $deviceLocation).padding().overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding(.horizontal, 30)
                SubtitleViewLight(input: "Purpose Of Device").padding(.top)
            
                Picker(selection: $devicePurposeUser, label:HStack{
                        Spacer()
                    ParagraphView(input: devicePurposeUser.rawValue.uppercased()).padding()
                    Image(systemName: "square.and.pencil")
                        Spacer()
                }.overlay(RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 1.5)).padding(.horizontal, 30)){
                    ForEach(devicePurpose.allCases){
                            Text($0.rawValue).font(.title2).textCase(.uppercase)
                        }
                    }.pickerStyle(MenuPickerStyle())
                
            }.foregroundColor(.black)
            
            Button(action: {
                withAnimation{
                    currentOnboardingView = .firstTime
                }
            }, label: {
                HStack{
                    SubtitleView(input: "Complete")
                    Image(systemName: "arrow.right").font(.title)
                }.padding(25).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding().transition(.slide).padding(.top)
            
            
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



