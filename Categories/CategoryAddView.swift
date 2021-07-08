//
//  CategoryAddView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 5/12/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct CategoryAddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationView{
                Form{
                    Section {
                        TextField("Name", text: $name)
                    }
                    
                    if image != nil{
                        self.image!
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                    }
                    else{
                        Text("No Image Found")
                            .frame(width: 300, height:  300, alignment: .center)
                    }
                    
                    HStack{
                        Button("Take Photo"){
                            self.sourceType = .camera
                            self.showingImagePicker.toggle()
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                    }
                    
                    Section{
                        Button("Add Category"){
                            addCategory()
                        }
                    }
                    .accentColor(.green)
                    .disabled(name == "")
                    
                    Section{
                        Button("Cancel"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }.accentColor(.red)
                }
                .navigationBarTitle("Add Category")
                .accentColor(.green)
                .fullScreenCover(isPresented: $showingImagePicker, onDismiss: loadImage){
                    ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
            }
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addCategory(){
        let newCategory = Category(context: self.moc)
        newCategory.name = self.name
        
        newCategory.id = UUID().uuidString
        
        if self.inputImage != nil {
            let imageData = self.inputImage?.jpegData(compressionQuality: 1.0)
            newCategory.image = imageData
        }
        
        do{
            try self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch{
            print("something went wrong...")
        }
    }
}

struct CategoryAddView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryAddView()
    }
}
