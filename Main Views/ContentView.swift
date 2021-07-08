//
//  ContentView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/8/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import Combine
import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.watering, ascending: true)]) var plantList: FetchedResults<Plant>

    @State private var showingAddPlant = false
    @State private var showingAllowReminder = false
    @ObservedObject var cathandler: categoryHandler
    
    var body: some View {
        mainMenuView(cathandler: cathandler)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        ContentView()
    }
}
