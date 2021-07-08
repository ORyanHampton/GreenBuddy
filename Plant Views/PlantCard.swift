//
//  PlantCard.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/11/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct PlantCard: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showingAlert = false
    
    var actionHandler: handleWaterFert = handleWaterFert()
    
    var plantItem: Plant
    var plantImage: Image?
    var plantComp: compareDates
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 170, height: 140)
//                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 2, antialiased: false).foregroundColor(.black))
                .foregroundColor(Color(#colorLiteral(red: 0.968095243, green: 0.9484168887, blue: 0.901052177, alpha: 1)))
                .shadow(radius: 7)
                .shadow(radius: 7)
            
            VStack{
                self.plantImage!
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 95)
//                    .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(lineWidth: 2, antialiased: false).foregroundColor(.black))
                    .cornerRadius(5)
//                    .shadow(radius: 5)
                VStack(){
                    HStack{
                        Text(plantItem.name!)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.themeText)
                    }
                    .frame(width: 150, height: 20, alignment: .leading)
                    
                    HStack{
                        Text("Water:")
                            .frame(width: 50, height: 20, alignment: .leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.1612525609, green: 0.7206786718, blue: 1, alpha: 1)))
                        Spacer()
                        Text(getWeekDay())
                            .frame(width: 90, height: 20, alignment: .leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.1612525609, green: 0.7206786718, blue: 1, alpha: 1)))
                    }
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: true, vertical: true)
                    .offset(y: -2)
                }
                .offset(y: -5)
                
//                .padding(.trailing)
                
            }
//            .frame(width: 300, height: 150, alignment: .leading)
//            .fixedSize(horizontal: true, vertical: true)
        }
    }
    
    init(for plant: Plant){
        self.plantItem = plant
        if plant.image != nil{
            plantImage = Image(uiImage: UIImage(data: plant.image!)!)
        }
        else{
            plantImage = Image("cacti")
        }
        
        plantComp = compareDates()
    }
    
    func getWeekDay() -> String{
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(plantItem.watering), to: waterDate)
//
//        let weekDay = Calendar.current.component(.weekday, from: modifiedDate!)
        
        let weeklySchedule : Dictionary<String, Bool> = ["sunday": plantItem.sunday, "monday":plantItem.monday, "tuesday":plantItem.tuesday, "wednesday":plantItem.wednesday, "thursday":plantItem.thursday, "friday":plantItem.friday, "saturday":plantItem.saturday]
        
        let today = Calendar.current.component(.weekday, from: Date())
        
        var day = ""
        switch today {
        case 1:
            day = "sunday"
        case 2:
            day = "monday"
        case 3:
            day = "tuesday"
        case 4:
            day = "wednesday"
        case 5:
            day = "thursday"
        case 6:
            day = "friday"
        case 7:
            day = "saturday"
        default:
            day = "Water sometime?"
        }
        
        for dayString in listDays(today){
            if dayString == day{
                let alreadyWatered = Calendar.current.isDate(Date(), equalTo: plantItem.lastWateringDate!, toGranularity: .day)
                if weeklySchedule[dayString]!{
                    if alreadyWatered{
                        continue
                    }
                    else{
                        return "Today"
                    }
                }
            }
            
            else if weeklySchedule[dayString]!{
                return "\(dayString)"
            }
        }
        
//        for (key, value) in weeklySchedule{
//            if key == day{
//                let alreadyWatered = (Date() == plantItem.lastWateringDate)
//                if value && !alreadyWatered{
//                    return "Water Today"
//                }
//            }
//            else if value{
//                return "Water: \(key)"
//            }
//        }
        
        
        return String("Next \(day)")
    }
    
    func listDays(_ today:Int) -> [String]{
        /*
         Returns a list for days of the week starting with today
         */
        var weekDayList = [String]()
        
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = today
        let today = calendar.startOfDay(for: Date())
        var week = [Date]()
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        for day in week{
            let weekDayNumber = Calendar.current.component(.weekday, from: day)
            var dayString = ""
            switch weekDayNumber {
            case 1:
                dayString = "sunday"
            case 2:
                dayString = "monday"
            case 3:
                dayString = "tuesday"
            case 4:
                dayString = "wednesday"
            case 5:
                dayString = "thursday"
            case 6:
                dayString = "friday"
            case 7:
                dayString = "saturday"
            default:
                dayString = "Water sometime?"
            }
            weekDayList.append(dayString)
            
        }
        
        return weekDayList
    }
    
    func daysToWater() -> Int{
        if plantItem.lastWateringDate == Date.distantPast{
            return Int(plantItem.watering)
        }
        else{
            let daysFromLastWater = plantComp.dateDifference(date1: plantItem.lastWateringDate!, date2: Date())
            let daysUntilWater = Int(plantItem.watering) - daysFromLastWater
            
            return daysUntilWater
        }
    }
}

//#if DEBUG
//struct PlantCard_Previews: PreviewProvider {
//    @FetchRequest(entity: Plant.entity(), sortDescriptors: [
//    NSSortDescriptor(keyPath: \Plant.name, ascending: true)]) var plantList: FetchedResults<Plant>
////    let indPlant: Plant
//
//    static var previews: some View {
//        let context = DataStore.shared.persistentContainer.viewContent
//        return PlantCard(for: plantList.first!).environment(\.managedObjectContext, context)
//    }
//}
//#endif
