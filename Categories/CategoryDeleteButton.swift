//
//  DeleteButton.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 5/18/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct CategoryDeleteButton: View {
    var category: Category
    @State var showAlert = false
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var cathandler: categoryHandler
    
    var body: some View {
        Button("\(category.name ?? "")"){
            self.showAlert.toggle()
        }
        .accentColor(.red)
        .alert(isPresented: $showAlert){
            Alert(title: Text("Are you sure you want to delete \(category.name!) category?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                            removeCategory(at: category)
                        }, secondaryButton: .cancel())
        }
    }
    
    func removeCategory(at offsets: Category){
        let category = offsets
        
        if category.id == cathandler.selectedCategory{
            cathandler.selectedCategory = ""
        }
        
        moc.delete(category)
        do{
            try moc.save()
        } catch{
            print("Removal Failed")
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        DeleteButton()
    }
}
