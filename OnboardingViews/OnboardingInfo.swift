//
//  OnboardingView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 1/29/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct OnboardingInfo: View {
    @State var status = false
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 160)
                .overlay(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(Color(.white))
                .shadow(radius: 5)
            
            VStack{
                Text("Notifications are used to let you know when to water or fertilize your plants")
                    .frame(width: 300, height: 100, alignment: .center)
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .multilineTextAlignment(.center)
                
                Button("Allow Notifications"){
                    checkStatus()
                    if status == false{
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                status = true
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                .disabled(status)
                .frame(width: 200, height: 35)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Capsule())
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

struct OnboardingInfo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInfo()
    }
}
