//
//  ListElements.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 1/25/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI

class ListElements: ObservableObject {
    @Published var items: [ListElement] = []
}
