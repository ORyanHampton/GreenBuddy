//
//  UpdateViewHandler.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 1/25/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit
import UserNotifications

class updateView: ObservableObject{
    @Published var daysSinceLastWatering:Int = 0
    @Published var daysSinceLastFertilize:Int = 0
    var givenPlant: Plant?
    let plantComp = compareDates()
    @State var listElements = ListElements()
    
    // MARK: - record types
    struct RecordType {
        static let Plants = "CD_Plant"
    }
    
    func dateComp(for givenDate: Date) -> Int{
        if givenDate == Date.distantPast{
            return 0
        }
        else{
            let today = Date()
            return plantComp.dateDifference(date1: givenDate, date2: today)
        }
    }
    
    func updateDaysWatering(for givenPlant: Plant){
        daysSinceLastWatering = dateComp(for: givenPlant.lastWateringDate!)
    }
    
    func updateDaysFertilize(for givenPlant: Plant){
        daysSinceLastFertilize = dateComp(for: givenPlant.lastFertDate!)
    }
    
    func checkDates(){
        // MARK: - Fetch From Cloudkit
        updateView.getRecords { (result) in
            switch result {
            case .success(let newItem):
                self.listElements.items.append(newItem)
                print("Successfully Fetched Item.")
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        //MARK: - Check For Watered Plant For Notification Refresh
        for plant in listElements.items{
            let lastFertDate = plant.lastFertDate
            let lastWaterDate = plant.lastWaterDate
            let fertDate = plant.fertDate
            let waterDate = plant.waterDate
            
            let newWateringDate = Calendar.current.date(byAdding: .day, value: Int(plant.watering), to: lastWaterDate)
            if waterDate == Date.distantPast{
                continue
            }
            else if newWateringDate != waterDate{
//                handleWaterFert().cancelReminderForRecord(plant.recordID!)
//                handleWaterFert().createReminder(plant, logType: "Water Log")
            }
            
            let newFertDate = Calendar.current.date(byAdding: .day, value: Int(plant.fertilizing), to: lastFertDate)
            if fertDate == Date.distantPast{
                continue
            }
            else if newFertDate != fertDate{
//                handleWaterFert().cancelReminderForRecord(plant.recordID!)
                handleWaterFert().createReminder(plant, logType: "Fertilize Log")
            }
        }
    }
    
    static func getRecords(completion: @escaping (Result<ListElement, Error>) -> ()) {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "CD_identifier", ascending: false)
        let query = CKQuery(recordType: RecordType.Plants, predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["CD_identifier", "CD_name", "CD_lastWateringDate", "CD_lastFertDate", "CD_watering", "CD_fertilize", "CD_wateringDate", "CD_fertDate"]
    
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let listRecordID = record.recordID
                print("Record ID: \(record.recordID)")
                guard let recordID = record["CD_identifier"] as? String else { return }
                print("RecordID: \(recordID)")
                guard let name = record["CD_name"] as? String else { return }
                print("name: \(name)")
                guard let lastWaterDate = record["CD_lastWateringDate"] as? Date else { return }
                print("lastWaterDate: \(lastWaterDate)")
                guard let lastFertDate = record["CD_lastFertDate"] as? Date else { return }
                print("lastFertDate: \(lastFertDate)")
                guard let watering = record["CD_watering"] as? Int64 else { return }
                print("watering: \(watering)")
                guard let fertilizing = record["CD_fertilize"] as? Int64 else { return }
                print("fertilizing: \(fertilizing)")
                guard let waterDate = record["CD_wateringDate"] as? Date else { return }
                print("waterDate: \(waterDate)")
                guard let fertDate = record["CD_fertDate"] as? Date else { return }
                print("fertDate: \(fertDate)")
                let listElement = ListElement(recordListID: listRecordID, recordID: recordID, name: name, lastWaterDate: lastWaterDate, lastFertDate: lastFertDate, watering: watering, fertilizing: fertilizing, waterDate: waterDate, fertDate: fertDate)
                completion(.success(listElement))
            }
        }
        
        operation.queryCompletionBlock = { (/*cursor*/ _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
            
        }
        
        CKContainer(identifier: "iCloud.com.hampton.GreenBuddy").privateCloudDatabase.add(operation)
    }
}
