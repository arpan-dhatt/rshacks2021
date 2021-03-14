//
//  NewDeviceView.swift
//  sound-app
//
//  Created by SaakethC on 3/14/21.
//

import SwiftUI
import CodeScanner

struct NewDeviceView: View {
    @State private var isShowingScanner = false
    
    var body: some View {
        VStack{
            Text("Sound Shot").font(.title).fontWeight(.bold).padding()
            HStack{
                Image(systemName: "dot.radiowaves.forward").font(.system(size: 200, weight: .ultraLight)).rotationEffect(.degrees(315)).offset(x:30,y:50)
                Image(systemName: "dot.radiowaves.forward").font(.system(size: 200, weight: .ultraLight)).rotationEffect(.degrees(135)).offset(x:-30,y:-50)
            }.padding()
            TitleViewBold(input: "Linking Your First Device").padding()
            ParagraphView(input: "Unbox your Sound Shot mic and scan the QR code on the top by pressing the button below").padding().padding(.horizontal).multilineTextAlignment(.center)
            Button(action: {
                self.isShowingScanner = true
            }, label: {
                HStack{
                    SubtitleView(input: "Scan QR Code")
                    Image(systemName: "qrcode.viewfinder").font(.title)
                }.padding(20).background(Color.black).cornerRadius(50.0).foregroundColor(.white).shadow(radius: 10.0)
            }).padding()
        }.sheet(isPresented: $isShowingScanner, content: {
            CodeScannerView(codeTypes: [.qr], simulatedData: "kl234jkl23j4lk24jlk234j", completion: handleScan).ignoresSafeArea()
        })
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        if let str = try? result.get() {
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            })
            print(str)
            Postman.shared.create_group()
        }
    }
}

struct NewDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        NewDeviceView()
    }
}
