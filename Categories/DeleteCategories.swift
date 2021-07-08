//
//  DeleteCategories.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 5/18/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct DeleteCategories: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.id, ascending: true)]) var categoryList: FetchedResults<Category>
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cathandler: categoryHandler
    
    @State var showAlert = false
    
    var body: some View {
        VStack(alignment: .center){
            Button("Done"){
                self.presentationMode.wrappedValue.dismiss()
            }
            .font(.system(size: 20))
            .foregroundColor(.blue)
            .padding(.top, 10)
            
            List{
                ForEach(categoryList, id: \.id){ category in
                    HStack{
                        CategoryDeleteButton(category: category, cathandler: cathandler)
                    }
                }
            }
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


struct DeleteCategories_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello")
//        DeleteCategories()
    }
}
