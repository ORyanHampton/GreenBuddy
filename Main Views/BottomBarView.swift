//
//  BottomBarView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/11/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack{
            if viewRouter.currentPage == "OnboardingView"{
                OnboardingView()
            }
            else if viewRouter.currentPage == "HomeView"{
                MotherView()
            }
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
    }
}
