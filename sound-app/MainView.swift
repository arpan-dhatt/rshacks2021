//
//  MainView.swift
//  sound-app
//
//  Created by SaakethC on 3/13/21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.Page == "Onboarding"{
            ContentView()
        }
        if viewModel.Page == "Intro"{
            ContentView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(ViewModel())
    }
}
