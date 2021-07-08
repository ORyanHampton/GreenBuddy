//
//  changeSettingsView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 11/1/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct changeSettingsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    var givenPlant: Plant
    
    @State private var watering: String = ""
    @State private var fertilizing: String = ""
    @State private var name: String = ""
    @State private var newImage: UIImage?
    @State private var image: Image?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var wateringNum: Int64 = 0
    @State private var showAlert = false
    @State private var plantNotes: String = ""
    @State private var category: Int = 0
    @State var categoryStringList = [String]()
    @State var categoryChanged = false
    @ObservedObject private var categories: categoryHandler
    
    init(for plantItem: Plant, cat: categoryHandler){
        givenPlant = plantItem
        _image = State(initialValue: Image(uiImage: UIImage(data: givenPlant.image!)!))
        _plantNotes = State(initialValue: plantItem.notes ?? "No Notes Found")
        categories = cat
        _categoryStringList = State(initialValue: getStringList())
        _category = State(initialValue: getIndex())
        loadImage()
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Plant Details")){
                    TextField("Name: \(givenPlant.name ?? "")", text: $name)
                    TextField("Days Between Fertilizing: \(givenPlant.fertilize)", text: $fertilizing)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Select Category")){
                    Picker(selection: $category, label: Text("Categories")){
                        ForEach(0 ..< categoryStringList.count){ index in
                            Text(categoryStringList[index]).tag(index)
                        }
                    }
                }
                
                Section(header: Text("Notes")){
                    TextEditor(text: $plantNotes)
                        .lineLimit(5)
                }
                Section(header: Text("Change Photo")){
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
                }
                
                Section{
                    Button("Save Changes"){
                        saveChanges()
                    }
                    Button("Cancel"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .accentColor(.blue)
                }
                
                Section{
                    Button("\(Image(systemName: "trash")) Delete Plant"){
                        self.showAlert.toggle()
                    }
                    .accentColor(.red)
                    .alert(isPresented: $showAlert){
                        Alert(title: Text("Are you sure you want to delete this plant?"), message: Text("There is no undo"), primaryButton: .destructive(Text("Delete")) {
                                        removePlants(at: givenPlant)
                                    }, secondaryButton: .cancel())
                    }
                }
            }
            .navigationBarTitle("Settings")
            .accentColor(.green)
            .fullScreenCover(isPresented: $showingImagePicker, onDismiss: loadImage){
                ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
            }
            .background(Color.black)
        }
    }
    
    // MARK: Delete Plant
    func removePlants(at offsets: Plant){
        let plant = offsets
        removeReminders(plant)
        
        moc.delete(plant)
        do{
            try moc.save()
        } catch{
            print("Removal Failed")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func removeReminders(_ plant:Plant){
        if plant.sunday{
            handleWaterFert().cancelReminders(plant, "sunday")
        }
        if plant.monday{
            handleWaterFert().cancelReminders(plant, "monday")
        }
        if plant.tuesday{
            handleWaterFert().cancelReminders(plant, "tuesday")
        }
        if plant.wednesday{
            handleWaterFert().cancelReminders(plant, "wednesday")
        }
        if plant.thursday{
            handleWaterFert().cancelReminders(plant, "thursday")
        }
        if plant.friday{
            handleWaterFert().cancelReminders(plant, "friday")
        }
        if plant.saturday{
            handleWaterFert().cancelReminders(plant, "saturday")
        }
    }
    
    func getStringList() -> [String]{
        var newList = [String]()
        
        for category in categories.categoriesList{
            if category.name == nil{
                
            }
            else{
                newList.append(category.name!)
            }
            
        }
        print("new List: \(newList)")
        
        return newList
    }
    
    func getIndex() -> Int{
        for (index, item) in categories.categoriesList.enumerated(){
            if givenPlant.category == item.id {
                return index
            }
        }
        
        return 0
    }
    
    
    // MARK: Save user changes to CoreData, which in turn saves to iCloud
    func saveChanges(){
        /*
         saves current plant with new input data
         */
        
        
        withAnimation {
            if self.name == ""{
                print("No new name.")
            }
            else{
                givenPlant.name = self.name
            }
            if self.watering == ""{
                print("No new watering time.")
            }
            else{
                givenPlant.watering = makeWateringInt(for: self.watering)
            }
            
            if self.fertilizing == ""{
                print("No new fertilizing time.")
            }
            else{
                givenPlant.fertilize = makeFertInt(for: self.fertilizing)
            }
            
            if self.plantNotes == givenPlant.notes ?? "No Notes Found"{
                print("No Changes to notes")
            }
            else{
                givenPlant.notes = plantNotes
            }
            
            if self.inputImage != nil{
                let imageData = self.inputImage?.jpegData(compressionQuality: 1.0)
                givenPlant.image = imageData
            }
            else{
                print("No New Image Added.")
            }
            
            if givenPlant.category == categories.categoriesList[category].id{
                print("No Category Added")
            }
            else{
                givenPlant.category = categories.categoriesList[category].id
            }
            
            do{
                try self.moc.save()
                self.presentationMode.wrappedValue.dismiss()
                categories.refreshList()
            } catch{
                print("something went wrong...")
            }
            
            
        }
    }
    
    func makeWateringInt(for stringNumber: String) -> Int64{
        /*
         changes watering string into an integer
         */
        if let num = Int(stringNumber){
            return Int64(num)
        }
        else{
            return 0
        }
    }
    
    func makeFertInt(for stringNumber: String) -> Int64{
        /*
         changes fertilizing string into an integer
         */
        if let num = Int(stringNumber){
            return Int64(num)
        }
        else{
            return 0
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

//struct changeSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        changeSettingsView()
//    }
//}
