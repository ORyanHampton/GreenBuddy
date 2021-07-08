//
//  settingsView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/30/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI
import UserNotifications

struct settingsView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var disableNotificationButton = false
    @State private var status = false
    @State private var disableButton = false
    @State private var showDeleteView = false
    @State private var showSettingsAlert = false
    @State private var showCreditView = false
    @State private var showAddCatView = false
    @ObservedObject var cathandler: categoryHandler
    
    var body: some View {
        Form{
            Section{
                    Button("Turn On Reminders"){
                        if status == false{
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("All set!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        else{
                            if self.disableButton == false{
                                self.showSettingsAlert.toggle()
                            }
                        }
                        checkStatus()
                    }
                    .alert(isPresented: $showSettingsAlert){
                        Alert(
                            title: Text("Turn on Notifications"),
                            message: Text("Please go to Settings and Allow Notifications"),
                            primaryButton: .cancel(Text("Cancel")),
                            secondaryButton: .default(Text("Settings"), action: {
                              if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                              }
                            }))
                    }
                }
                .disabled(disableButton)
                .onAppear{checkStatus()}
            
            Section{
                Button("\(Image(systemName: "trash")) Delete Category") {
                    self.showAddCatView.toggle()
                }.sheet(isPresented: $showAddCatView, content: {
                    DeleteCategories(cathandler: cathandler).environment(\.managedObjectContext, self.moc)
                })
                .foregroundColor(.red)
            }
            
            Section{
                Button("\(Image(systemName: "trash")) Delete Plants"){
                    self.showDeleteView.toggle()
                }.sheet(isPresented: $showDeleteView, content: {
                    massDeleteView().environment(\.managedObjectContext, self.moc)
                })
                .foregroundColor(.red)
            }
            
            Section{
                Button("Credits & FeedBack"){
                    self.showCreditView.toggle()
                }
                .sheet(isPresented: $showCreditView, content: {
                    CreditsView().environment(\.managedObjectContext, self.moc)
                })
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
                self.disableButton = true
            default:
                self.status = true
            }
        }
    }
}

struct settingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        settingsView()
    }
}
