//
//  todayView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 12/22/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct TodayView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Plant.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Plant.watering, ascending: true)]) var plantList: FetchedResults<Plant>
    @Environment(\.presentationMode) var presentationMode
    var plantComp: compareDates = compareDates()
    var actionHandler: handleWaterFert = handleWaterFert()
    @State var cathandler = categoryHandler()
    
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
                    ZStack{
                        WaveShape(yOffset: 15)
                            .fill(Color.themeWave)
                            .frame(height: 200)
                            .shadow(radius: 6)
                        WaveShape(yOffset: 0.5)
                            .fill(Color(#colorLiteral(red: 0.3285531402, green: 0.5850883722, blue: 0.1817225814, alpha: 1)))
                            .frame(height: 200)
                            .shadow(radius: 6)
                        Text("Today")
                            .frame(width: UIScreen.main.bounds.width-10)
                            .scaledToFit()
                            .font(.title)
                            .offset(y: 20)
                        
                        Spacer()
                    }
                    Spacer()
                }.edgesIgnoringSafeArea(.top)
                
                VStack{
                    ScrollView{
                        if #available(iOS 14.0, *) {
                            LazyVGrid(columns: layout, spacing: 15, content:{
                                ForEach(plantList, id: \.identifier){ plant in
                                    if getWeekDay(plant){
                                        HStack {
                                            NavigationLink(destination: PlantInfoView(for: plant, cat: cathandler)){
                                                PlantCard(for: plant)
                                            }
                                        }
                                        .contextMenu{
                                            VStack{
                                                Button(action:{
                                                    saveChanges(logType: "Water Log", plantItem: plant)
                                                }){
                                                    Text("Log Watering.")
                                                    Image(systemName: "drop")
                                                }
                                                
                                                Button(action:{
                                                    saveChanges(logType: "Fertilize Log", plantItem: plant)
                                                }){
                                                    Text("Log Fertilizing.")
                                                    Image(systemName: "leaf")
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    func getWeekDay(_ plantItem: Plant) -> Bool{
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
                        return false
                    }
                    else{
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func listDays(_ today:Int) -> [String]{
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
    
    func daysToWater(for plantItem: Plant) -> Int{
        if plantItem.lastWateringDate == Date.distantPast{
            return Int(plantItem.watering)
        }
        else{
            let daysFromLastWater = plantComp.dateDifference(date1: plantItem.lastWateringDate!, date2: Date())
            let daysUntilWater = Int(plantItem.watering) - daysFromLastWater
            
            return daysUntilWater
        }
    }
    
    func saveChanges(logType type:String, plantItem: Plant){
        if type == "Water Log"{
            plantItem.lastWateringDate = Date()
        } else if type == "Fertilize Log" {
            plantItem.lastFertDate = Date()
        }
        
        actionHandler.cancelReminders(plantItem)
        
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
        
        actionHandler.createReminder(for: plantItem, logType: type)
    }
}





struct todayView_Previews: PreviewProvider {
    static var previews: some View {
//        Text("Hello")
                TodayView()
    }
}
