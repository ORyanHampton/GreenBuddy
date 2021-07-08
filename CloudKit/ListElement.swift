//
//  ListElement.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 1/25/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit

struct ListElement: Identifiable {
    var id = UUID()
    var recordListID: CKRecord.ID?
    var recordID: String?
    var name: String
    var lastWaterDate: Date
    var lastFertDate: Date
    var watering: Int64
    var fertilizing: Int64
    var waterDate: Date?
    var fertDate: Date?
}
