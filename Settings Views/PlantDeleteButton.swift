//
//  PlantDeleteButton.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 5/18/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct PlantDeleteButton: View {
    var plant: Plant
    @State var showAlert = false
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {
        Button("\(plant.name ?? "")"){
            self.showAlert.toggle()
        }
        .accentColor(.red)
        .alert(isPresented: $showAlert){
            Alert(title: Text("Are you sure you want to delete \(plant.name!)?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                            removePlants(at: plant)
                        }, secondaryButton: .cancel())
        }
    }
    
    func removePlants(at offsets: Plant){
        let plant = offsets
        removeReminders(plant)
        
        moc.delete(plant)
        do{
            try moc.save()
        } catch{
            print("Removal Failed")
        }
    }
    
    func removeReminders(_ plant:Plant){
        if plant.sunday{
            handleWaterFert().cancelReminders(plant, "sunday")
        }
        if plant.monday{
            handleWaterFert().cancelReminders(plant, "monday")
        }
        if plant.tuesday{
            handleWaterFert().cancelReminders(plant, "tuesday")
        }
        if plant.wednesday{
            handleWaterFert().cancelReminders(plant, "wednesday")
        }
        if plant.thursday{
            handleWaterFert().cancelReminders(plant, "thursday")
        }
        if plant.friday{
            handleWaterFert().cancelReminders(plant, "friday")
        }
        if plant.saturday{
            handleWaterFert().cancelReminders(plant, "saturday")
        }
    }
}

struct PlantDeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        PlantDeleteButton()
    }
}
