//
//  AddView.swift
//  PlantTracker
//
//  Created by O'Ryan Hampton on 10/8/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI
import UserNotifications

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var watering = ""
    @State private var fertlilize = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var wateringNum: Int64 = 0
    @State private var fertNum: Int64 = 0
    @State private var reminders = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var setSunday = false
    @State private var setSaturday = false
    @State private var setMonday = false
    @State private var setTuesday = false
    @State private var setWednesday = false
    @State private var setThursday = false
    @State private var setFriday = false
    
    init(){
        self.name = ""
        self.watering = ""
        self.image = nil
        inputImage = nil
        wateringNum = 0
        fertNum = 0
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Plant Info")) {
                    TextField("Name", text: $name)
//                    TextField("Days Between Watering", text: $watering)
//                        .keyboardType(.numberPad)
                    TextField("Days Between Fertilizing", text: $fertlilize)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Weekly Schedule")) {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            
                            // MARK: Sunday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("SUN")
                                        .foregroundColor(.black)
                                    Image(systemName: setSunday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .animation(.easeInOut)
                                        .foregroundColor(setSunday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setSunday.toggle()
                            }
                            
                            // MARK: Monday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("MON")
                                        .foregroundColor(.black)
                                    Image(systemName: setMonday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(setMonday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setMonday.toggle()
                            }
                            
                            // MARK: Tuesday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("TUE")
                                        .foregroundColor(.black)
                                    Image(systemName: setTuesday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(setTuesday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setTuesday.toggle()
                            }
                            
                            // MARK: Wednesday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("WED")
                                        .foregroundColor(.black)
                                    Image(systemName: setWednesday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(setWednesday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setWednesday.toggle()
                            }
                            
                            // MARK: Thursday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("THU")
                                        .foregroundColor(.black)
                                    Image(systemName: setThursday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(setThursday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setThursday.toggle()
                            }
                            
                            // MARK: Friday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("FRI")
                                        .foregroundColor(.black)
                                    Image(systemName: setFriday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(setFriday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setFriday.toggle()
                            }
                            
                            // MARK: Saturday
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.themeDate)
                                    .frame(width: 80, height: 100)
                                VStack{
                                    Text("SAT")
                                        .foregroundColor(.black)
                                    Image(systemName: setSaturday ? "drop.fill" : "drop")
                                        .font(.system(size: 30))
                                        .foregroundColor(setSaturday ? .blue : .red)
                                }
                            }
                            .onTapGesture {
                                self.setSaturday.toggle()
                            }
                        }
                    }
                    
                }
                .cornerRadius(10)
                
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
                    
//                    Button("From Gallary"){
//                        self.sourceType = .photoLibrary
//                        self.showingImagePicker.toggle()
//                    }.buttonStyle(BorderlessButtonStyle())
                }
                
                Section{
                    Button("Add Plant"){
                        addPlant()
                    }
                }.disabled(scheduleSet())
                
                Section{
                    Button("Cancel"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }.accentColor(.red)
                
            }
            .navigationBarTitle("Add New Plant")
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
    
    func scheduleSet() -> Bool{
        var disableSubmit = true
        
        if setSunday{
            disableSubmit = false
        }
        else if setMonday{
            disableSubmit = false
        }
        else if setTuesday{
            disableSubmit = false
        }
        else if setWednesday{
            disableSubmit = false
        }
        else if setThursday{
            disableSubmit = false
        }
        else if setFriday{
            disableSubmit = false
        }
        else if setSaturday{
            disableSubmit = false
        }
        
        return disableSubmit
    }
    
    // MARK: Save Record to Core Data
    func addPlant(){
        /*
         Creates a new core data object for a specific plant created with user input
         */
        let newPlant = Plant(context: self.moc)
        newPlant.name = self.name
        
        newPlant.identifier = UUID()
        
        //changes watering string into an integer
//        newPlant.watering = makeWateringInt(for: self.watering)
        
        //add the days of the week to water into the CD element
        newPlant.sunday = setSunday
        newPlant.monday = setMonday
        newPlant.tuesday = setTuesday
        newPlant.wednesday = setWednesday
        newPlant.thursday = setThursday
        newPlant.friday = setFriday
        newPlant.saturday = setSaturday
        
        //changes fert string into an integer
        newPlant.fertilize = makeFertInt(for: self.fertlilize)
        
        if self.inputImage != nil{
            let imageData = self.inputImage?.jpegData(compressionQuality: 1.0)
            newPlant.image = imageData
        }
        else{
            let randomInt = Int.random(in: 0 ... 2)
            var imageName = ""
            
            if randomInt == 0{
                imageName = "cacti"
            }
            else if randomInt == 1 {
                imageName = "lily"
            }
            else {
                imageName = "Monstera"
            }
            
            let imageData = UIImage(named: imageName)?.jpegData(compressionQuality: 1.0)
            newPlant.image = imageData
        }
        
        newPlant.creationDate = Date()
        newPlant.lastFertDate = Date.distantPast
        newPlant.lastWateringDate = Date.distantPast
        
        do{
            try self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch{
            print("something went wrong...")
        }
        
        //creates reminders based on weekly schedule specified
        handleWaterFert().checkSchedule(newPlant, "")
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
}

// extension for keyboard to dismiss
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
