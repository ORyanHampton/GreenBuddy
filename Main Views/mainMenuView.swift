//
//  mainMenuView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 11/4/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct mainMenuView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.watering, ascending: true)])
    var plantList: FetchedResults<Plant>
    
    var plantComp: compareDates = compareDates()
    var actionHandler: handleWaterFert = handleWaterFert()
    @State private var showingAddPlant = false
    @State private var showingAllowReminder = false
    @State private var showAlert = false
    @State private var change = false
    @State private var showCategoryAddView = false
    @ObservedObject var cathandler: categoryHandler
    
    var categoryList = [Plant]()
    
    let ninetyPercent = UIScreen.main.bounds.width * 0.9
    let layout = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50))
    ]
    
    let save = [GridItem(.fixed(500))]
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.themeBackground
                
                VStack{
                    layeredWaveView(title: "Plants")
                    Spacer()
                }.edgesIgnoringSafeArea(.top)
                
                VStack{
                    HStack{
                        categoryView(cathandler: cathandler)
                    }
                    
                    ScrollView(.vertical){
                        LazyVGrid(columns: layout, spacing: 15, content:{
                        ForEach(plantList, id: \.identifier){ plant in
                                if fitsCategory(plant){
                                    HStack {
                                        NavigationLink(destination: PlantInfoView(for: plant, cat: cathandler)){
                                            PlantCard(for: plant)
                                        }
                                    }
                                    .padding(.top)
                                    .contextMenu{
                                        VStack{
                                            Button(action:{
                                                saveChanges(logType: "Water Log", plantItem: plant)
                                            }){
                                                Text("Log Watering")
                                                Image(systemName: "drop")
                                            }
                                            
                                            Button(action:{
                                                saveChanges(logType: "Fertilize Log", plantItem: plant)
                                            }){
                                                Text("Log Fertilizing")
                                                Image(systemName: "leaf")
                                            }
                                        }
                                    }
                                }
                            }
                        } )
                    }
                    .cornerRadius(10)
                }

                ZStack{
                    Menu {
                                Button("Cancel", action: {})
                                Button("Add Category", action: {self.showCategoryAddView.toggle()})
                                Button("Add Plant", action: {self.showingAddPlant.toggle()})
                            } label: {
                                Label("", systemImage: "plus.circle")
                                    .foregroundColor(Color(#colorLiteral(red: 0.311760813, green: 0.7448924184, blue: 0.525581181, alpha: 1)))
                                    .font(.system(size: 40))
                            }
                        
                }
                .offset(x: 140, y: 245)
                .sheet(isPresented: $showCategoryAddView){
                    CategoryAddView().environment(\.managedObjectContext, self.moc)
                }
                
            }
            .sheet(isPresented: $showingAddPlant){
                AddView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func fitsCategory(_ plant:Plant) -> Bool{
        if cathandler.selectedCategory == ""{
            return true
        }
        else if plant.category == cathandler.selectedCategory{
            return true
        }
        
        return false
    }
    
    func removePlants(at offsets: Plant){
        let plant = offsets
        moc.delete(plant)
        
        do{
            try moc.save()
        } catch{
            print("Removal Failed")
        }
    }
    
    func deletePlant(at offsets: IndexSet){
        for index in offsets{
            let plant = plantList[index]
            moc.delete(plant)
        }
        
        do{
            try moc.save()
        } catch{
            print("Removal Failed")
        }
    }
    
    func saveChanges(logType type:String, plantItem: Plant){
        withAnimation {
//            let today = Date()
//            let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(plantItem.watering), to: today)
            
            if type == "Water Log"{
                plantItem.lastWateringDate = Date()
//                plantItem.wateringDate = modifiedDate
            } else if type == "Fertilize Log" {
                plantItem.lastFertDate = Date()
//                plantItem.fertDate = modifiedDate
            }
            
//            actionHandler.cancelReminders(plantItem)
            
            do{
                try self.moc.save()
            } catch{
                print("something went wrong...\(error)")
            }
            
            let updateManager = updateView()
            
            if type == "Water Log"{
                updateManager.updateDaysWatering(for: plantItem)
            } else if type == "Fertilize Log"{
                updateManager.updateDaysFertilize(for: plantItem)
            }
            
//            handleWaterFert().checkSchedule(plantItem)
            
//            actionHandler.checkAuthorizationStatus(plant: plantItem, logType: type)
        }
    }
}

struct mainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        mainMenuView()
    }
}
