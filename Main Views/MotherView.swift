//
//  MotherView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/30/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    init(){
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
    }
    @ObservedObject var cathandler: categoryHandler = categoryHandler()
    
    var body: some View {
        
        
        TabView{
            ContentView(cathandler: cathandler)
                .tabItem {
                    Image(systemName: "list.dash")
                        .foregroundColor(.gray)
                    Text("Home")
                }
            
            TodayView()
                .tabItem{
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.gray)
                    Text("Today")
                }
            
            settingsView(cathandler: cathandler)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.gray)
                    Text("Options")
                }
        }
        .accentColor(.green)
        
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
