//
//  InfoButtonsView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/13/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct InfoButtonsView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var gallaryViewIsShowing = false
    let backgroundColor = Color(UIColor.secondarySystemBackground)
    var actionHandler: handleWaterFert = handleWaterFert()
    var plantItem:Plant
    let formatter = DateFormatter()
    @State var ButtHeight: CGFloat = 60
    @State var ButtWidth: CGFloat = 60
    @State var waterPressed = false
    @State var fertPressed = false
    
    var body: some View {
        HStack(alignment: .center){
            ZStack {
                Button(action: {
                    saveChanges(logType: "Water Log", plantItem: plantItem)
                    self.waterPressed.toggle()
                })
                {
                    Image(systemName: "drop")
                        .rotationEffect(.degrees(waterPressed ? 360 : 0))
                        .font(.system(size: 35))
                        .foregroundColor(Color.themeBackground)
                        .animation(.spring(response: 0.2, dampingFraction: 5, blendDuration: 1))
                }
                .padding(15)
                .background(Color.themeButtons)
                .mask(Circle())
                .shadow(color: .black, radius: 5)
                .zIndex(10)
                .alert(isPresented: $waterPressed){
                    Alert(title: Text("Watering Logged!"), message: Text("\(plantItem.name!) thirst is satisfied! 😋"), dismissButton: .default(Text("Got it!")))
                }
            }
            .padding(.trailing, 100)
            
            ZStack{
                Button(action: {
                    saveChanges(logType: "Fertilize Log", plantItem: plantItem)
                    self.fertPressed.toggle()
                })
                {
                    Image(systemName: "leaf")
                        .rotationEffect(.degrees(fertPressed ? 360 : 0))
                        .font(.system(size: 35))
                        .foregroundColor(Color.themeBackground)
                        .animation(.spring(response: 0.2, dampingFraction: 5, blendDuration: 1))
                }
                .padding(13)
                .background(Color.themeButtons)
                .mask(Circle())
                .shadow(color: .black, radius: 5)
                .zIndex(10)
                .alert(isPresented: $fertPressed){
                    Alert(title: Text("Fertilize Logged!"), message: Text("\(plantItem.name!) hunger is satisfied! 🤤"), dismissButton: .default(Text("Got it!")))
                }
            }
        }
    }
    
    func saveChanges(logType type:String, plantItem: Plant){
//        let today = Date()
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(plantItem.watering), to: today)
        
        if type == "Water Log"{
            plantItem.lastWateringDate = Date()
//            plantItem.wateringDate = modifiedDate
        } else if type == "Fertilize Log" {
            plantItem.lastFertDate = Date()
//            plantItem.fertDate = modifiedDate
        }
        
//        actionHandler.cancelReminders(plantItem)
        
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
        
//        actionHandler.checkSchedule(plantItem)
    }
    
    func dateFormatWater(for inputDate:Date) -> String{
        if inputDate == Date.distantPast{
            return "No Date Found."
        }
        else{
            let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(plantItem.watering), to: inputDate)
            
            formatter.dateFormat = "EEEE, MMM dd, yyyy"
//            let dateString = formatter.string(from: inputDate)
            let dateString: String = formatter.string(from: modifiedDate!)
//            dateString = "\(getWeekDay()), \(dateString)"
            return dateString
        }
    }
    
    func dateFormatFert(for inputDate:Date) -> String{
        if inputDate == Date.distantPast{
            return "No Date Found."
        }
        else{
            let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(plantItem.fertilize), to: inputDate)
            
            formatter.dateFormat = "EEEE, MMM dd, yyyy"
//            let dateString = formatter.string(from: inputDate)
            let dateString: String = formatter.string(from: modifiedDate!)
//            dateString = "\(getWeekDay()), \(dateString)"
            return dateString
        }
    }
    
    func getWeekDay() -> String{
        let waterDate = plantItem.lastWateringDate!
        let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(plantItem.watering), to: waterDate)
        
        let weekDay = Calendar.current.component(.weekday, from: modifiedDate!)
        
        var day = ""
        switch weekDay {
        case 1:
            day = "Sunday"
        case 2:
            day = "Monday"
        case 3:
            day = "Tuesday"
        case 4:
            day = "Wednesday"
        case 5:
            day = "Thursday"
        case 6:
            day = "Friday"
        case 7:
            day = "Saturday"
        default:
            day = "Water sometime?"
        }
        return String(day)
    }
}
struct InfoButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        InfoButtonsView(plantItem: greatPlant!)
//        InfoButtonsView()
    }
}
