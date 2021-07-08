//
//  categoryImage.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 5/11/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct categoryImage: View {
    let categoryItem: Category
    @ObservedObject var cathandler: categoryHandler
    
    var categoryImage: Image?
    let categoryStringImage: String?
    @State var categorySelected = false
    
    var body: some View {
        if categoryItem.image != nil{
            VStack{
                ZStack{
                    Circle()
                        .frame(width: 110, height: 80)
                        .foregroundColor(categoryItem.id == cathandler.selectedCategory ? Color(#colorLiteral(red: 0, green: 0.4789391756, blue: 1, alpha: 1)) : Color.clear)
                    categoryImage!
                        .resizable()
//                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 70)
                }
            }
            .onTapGesture {
                if cathandler.selectedCategory == categoryItem.id{
                    cathandler.selectCategory("")
                }
                else{
                    cathandler.selectCategory(categoryItem.id!)
                }
            }
        }
        else{
            VStack{
                ZStack{
                    Circle()
                        .frame(width: 110, height: 80)
                        .foregroundColor(categoryItem.id == cathandler.selectedCategory ? Color(#colorLiteral(red: 0, green: 0.4789391756, blue: 1, alpha: 1)) : Color.clear)
                    Circle()
                       .frame(width: 100, height: 70)
                       .foregroundColor(.white)
                       Text(categoryStringImage!)
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    
                }
            }
            .onTapGesture {
                if cathandler.selectedCategory == categoryItem.id{
                    cathandler.selectCategory("")
                }
                else{
                    cathandler.selectCategory(categoryItem.id!)
                }
            }
        }
    }
    
    init(for cat:Category, catHandler: categoryHandler){
        var newString: String? = ""
        
        if cat.image != nil{
            categoryImage = Image(uiImage: UIImage(data: cat.image!)!)
        }
        else{
            let categoryName = cat.name
            let nameList = [Character](categoryName!)
            let firstChar = String(nameList[0])
            let secondChar = String(nameList[1])
            
            newString?.append(firstChar)
            newString?.append(secondChar)
        }
        categoryItem = cat
        categoryStringImage = newString
        cathandler = catHandler
    }
}

struct categoryImage_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
//        categoryImage()
    }
}
