//
//  dateHandler.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/21/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

class compareDates{
    func dateDifference(date1 firstDate: Date, date2 secondDate: Date) -> Int{
        let diffComponents = Calendar.current.dateComponents([.day], from: firstDate, to: secondDate)
        let days = diffComponents.day
        
        return days!
    }
}
