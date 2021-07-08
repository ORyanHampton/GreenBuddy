//
//  ViewRouter.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/30/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI

class ViewRouter: ObservableObject{
    @Published var currentPage: String
    
    init(){
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore"){
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "OnboardingView"
        }
        else{
            currentPage = "HomeView"
        }
    }
}
