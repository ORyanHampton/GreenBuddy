//
//  categoryView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 4/30/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct categoryView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.id, ascending: true)])
    var categoryList: FetchedResults<Category>
    let ninetyPercent = UIScreen.main.bounds.width * 0.9
    @ObservedObject var cathandler: categoryHandler
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 0){
                ForEach(categoryList, id: \.id){ category in
                    categoryImage(for: category, catHandler: cathandler)
                }
            }
        }
        .onAppear(){
            if cathandler.categoriesList != [Category]() && checkForNewCategory(){
                
            }
            else{
                setCategoryList()
            }
        }
        .frame(width: ninetyPercent, height: 50)
        .padding(.bottom)
    }
    
    func checkForNewCategory() -> Bool{
        if cathandler.categoriesList.count < categoryList.count{
            return false
        }
        else{
            return true
        }
    }
    
    func setCategoryList(){
        var categoryNameList = [Category]()
        for category in categoryList{
            categoryNameList.append(category)
        }
        cathandler.categoriesList = categoryNameList
    }
}



struct categoryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
//        categoryView()
    }
}
