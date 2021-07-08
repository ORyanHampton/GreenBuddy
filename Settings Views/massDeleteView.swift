//
//  massDeleteView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 12/19/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct massDeleteView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.watering, ascending: true)]) var plantList: FetchedResults<Plant>
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAlert = false
    
    var body: some View {
        VStack(alignment: .center){
            Button("Done"){
                self.presentationMode.wrappedValue.dismiss()
            }
            .font(.system(size: 20))
            .foregroundColor(.blue)
            .padding(.top, 10)
            
            List{
                ForEach(plantList, id: \.name){ plant in
                    PlantDeleteButton(plant: plant)
                }
            }
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

struct massDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        massDeleteView()
    }
}
