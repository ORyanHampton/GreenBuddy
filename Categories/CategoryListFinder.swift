//
//  CategoryListFinder.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 4/22/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class categoryHandler: ObservableObject{
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.id, ascending: true)])
    var fetchedList: FetchedResults<Category>
    @Published var selectedCategory = ""
    @Published var categoriesList = [Category]()
    
//    init(){
//        let newCategory = Category(context: self.moc)
//        newCategory.name = ""
//        newCategory.id = UUID().uuidString
//        
//        do{
//            try self.moc.save()
//        } catch{
//            print("Something went wrong...")
//        }
//        
//        categoriesList.append(newCategory)
//    }
    
    func refreshList(){
        var freshList = [Category]()
        for category in fetchedList{
            freshList.append(category)
        }
        
        if freshList.count == 0 && fetchedList.count != 0{
            refreshList()
        }
        else{
            categoriesList = freshList
        }
    }
    
    func selectCategory(_ category: String){
        selectedCategory = category
    }
    
    func setCategoryList(_ list: [Category]){
        categoriesList = list
    }
}

