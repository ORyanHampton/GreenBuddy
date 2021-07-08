//
//  infoFrameView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 11/4/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct infoFrameView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewUpdater = updateView()
    var plantItem:Plant
    let formatter = DateFormatter()
    let quarterWidth = UIScreen.main.bounds.width*0.05
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 380)
                .overlay(RoundedRectangle(cornerRadius: 20))
                //                .foregroundColor(Color(#colorLiteral(red: 0.678792838, green: 0.7050243343, blue: 0.9152001336, alpha: 1)))
                .foregroundColor(Color(#colorLiteral(red: 0.968095243, green: 0.9484168887, blue: 0.901052177, alpha: 1)))
                //                .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                .shadow(radius: 5)
            
            VStack {
                // Watering Dates and days since last watering
                VStack(alignment: .leading){
                    HStack{
                        Text("Watering:")
                            .font(.system(size: 27))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "drop")
                            .foregroundColor(.blue)
                            .padding(.trailing, 20)
                    }

                    let daysSinceLastWater = self.viewUpdater.dateComp(for: (plantItem.lastWateringDate)!)
                    Text("Days Since Watering: \(daysSinceLastWater)")
                        .foregroundColor(.black)
                    
                    if plantItem.lastWateringDate == Date.distantPast{
                        Text("Last Watering Date: --/--/--")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                    else{
                        Text("Last Watering: \(dateFormat(for: (plantItem.lastWateringDate) ?? Date().addingTimeInterval(86400)))")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(width: 340, height: 110, alignment: .topLeading)
//                .padding(.top, 10)
                
                // Fertilizing Dates and days since last fertilizing
                VStack(alignment: .leading){
                    HStack{
                        Text("Fertilizing:")
                            .font(.system(size: 27))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "leaf")
                            .foregroundColor(.green)
                            .padding(.trailing, 20)
                    }
                    
                    
                    let daysSinceLastFert = self.viewUpdater.dateComp(for: (plantItem.lastFertDate)!)
                    Text("Days Since Fertilizing: \(daysSinceLastFert)")
                        .foregroundColor(.black)
                    
                    if plantItem.lastFertDate == Date.distantPast{
                        Text("Last Fertilizing Date: --/--/--")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        //                            Text("No Date Found.")
                    }
                    else{
                        Text("Last Fertilizing: \(dateFormat(for: (plantItem.lastFertDate) ?? Date().addingTimeInterval(86400)))")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        //                            Text("\(dateFormat(for: (plantItem.lastFertDate) ?? Date().addingTimeInterval(86400)))")
                    }
                }
                .frame(width: 340, height: 90, alignment: .topLeading)
            
                VStack(alignment: .leading){
                    HStack{
                        Text("Weekly Schedule:")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
    //                        .padding(.leading, quarterWidth)
                        Spacer()
                    }
                }
                .frame(width: 340, height: 20, alignment: .topLeading)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(#colorLiteral(red: 0.311760813, green: 0.7448924184, blue: 0.525581181, alpha: 1)))
                        .frame(width: 340, height: 115)
                        .shadow(radius: 5)
                        .offset(x: -10)
                    
                    ScrollView(.horizontal){
                        HStack{
                            // MARK: Sunday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("SUN")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.sunday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.sunday ? .blue : .red)
                                        .animation(.spring())
                                }
                            }
                            .onTapGesture {
                                plantItem.sunday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "sunday")
                                handleWaterFert().checkSchedule(plantItem, "sunday")
                            }
                            
                            // MARK: Monday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("MON")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.monday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.monday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                plantItem.monday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "monday")
                                handleWaterFert().checkSchedule(plantItem, "monday")
                            }

                            // MARK: Tuesday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("TUE")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.tuesday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.tuesday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                plantItem.tuesday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "tuesday")
                                handleWaterFert().checkSchedule(plantItem, "tuesday")
                            }
                            
                            // MARK: Wednesday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("WED")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.wednesday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.wednesday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                plantItem.wednesday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "wednesday")
                                handleWaterFert().checkSchedule(plantItem, "wednesday")
                            }
                            
                            // MARK: Thursday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("THU")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.thursday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.thursday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                plantItem.thursday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "thursday")
                                handleWaterFert().checkSchedule(plantItem, "thursday")
                            }
                            
                            // MARK: Friday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("FRI")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.friday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.friday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                plantItem.friday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "friday")
                                handleWaterFert().checkSchedule(plantItem, "friday")
                            }
                            
                            
                            // MARK: Saturday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("SAT")
                                        .foregroundColor(.black)
                                    Image(systemName: plantItem.saturday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(plantItem.saturday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                plantItem.saturday.toggle()
                                
                                do{
                                    try self.moc.save()
                                } catch{
                                    print("something went wrong...")
                                }
                                
                                handleWaterFert().cancelReminders(plantItem, "saturday")
                                handleWaterFert().checkSchedule(plantItem, "saturday")
                            }
                        }
                    }
                    .cornerRadius(10)
                    .frame(width: 330)
                    .offset(x: -10)
                    .shadow(radius: 5)
                }
            }
            .padding(.leading, quarterWidth)
        }
    }
    
    func dateFormat(for inputDate:Date) -> String{
        if inputDate == Date.distantPast{
            return "No Date Found."
        }
        else{
            formatter.dateFormat = "EEEE, MMM dd, yyyy"
//            let dateString = formatter.string(from: inputDate)
            let dateString: String = formatter.string(from: inputDate)
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

struct infoFrameView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//        infoFrameView()
    }
}
