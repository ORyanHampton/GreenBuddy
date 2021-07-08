//
//  PersistenceController.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 1/25/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
            CKContainer.default().accountStatus { (accountStatus, error) in
                if accountStatus == .available{
                    print("iCloud app container and private database is available")
                }
                else{
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                // Completion handler when settings opened
                            })
                        }
                    }
                    print("iCloud not available: \(String(describing: error?.localizedDescription))")
                }
            }
        
        container = NSPersistentCloudKitContainer(name: "GreenBuddy")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
