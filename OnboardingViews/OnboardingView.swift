//
//  OnboardingView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/29/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var status = false
    
    var body: some View {
        ZStack{
            Color.themeBackground
                .ignoresSafeArea()
            
            VStack{
                Text("GreenBuddy")
//                    .font(.headline)
                    .foregroundColor(Color.themeWave)
                    .font(.system(size: 50))
                
                ImageView(for: Image("lily"))
                VStack{
                    OnboardingInfo()
                }
                .padding(.top, 25)
                
                Spacer()
                
                HStack{
                    Button("Start Tracking!"){
                        viewRouter.currentPage = "HomeView"
                    }
                    .animation(.easeInOut)
                    .frame(width: 150, height: 35)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .clipShape(Capsule())
                    .offset(y: -100)
                }
            }
        }
    }
    
    func checkStatus(){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.status = false
            case .authorized, .provisional:
                self.status = true
            default:
                self.status = true
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
