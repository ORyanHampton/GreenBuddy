//
//  PlantInfoView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/10/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct PlantInfoView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewUpdater = updateView()
    @State var daysSinceLastWater: Int = 0
    @State private var showSettings = false
    @State var change = false
    @State var showNotes = false
    @ObservedObject var categories: categoryHandler
    var plantImage: Image?
    var greatPlant: Plant?
    
    
    var body: some View {
        ZStack{
           Color.themeBackground
            
            
            VStack{
                VStack{
                    ZStack(alignment: .top) {
                        WaveShape(yOffset: change ? -0.6 : 0.6)
                            .fill(Color(#colorLiteral(red: 0.3770245515, green: 0.6681438871, blue: 0.2114421766, alpha: 1)))
                            .frame(height: 180)
                            .animation(Animation.easeOut(duration: 15).repeatForever(autoreverses: true))
                            .shadow(radius: 6)
                            .onAppear(perform: {change = true})
                        
                        WaveShape(yOffset: change ? 0.7 : -0.7)
                            .fill(Color(#colorLiteral(red: 0.3046105911, green: 0.5444885084, blue: 0.1670262372, alpha: 1)))
                            .frame(height: 200)
                            .animation(Animation.easeOut(duration: 15).repeatForever(autoreverses: true))
                            .shadow(radius: 6)
                            .onAppear(perform: {change = true})
                        
                        WaveShape(yOffset: change ? 0.5 : -0.5)
                            .fill(Color.themeWave)
                            .frame(height: 160)
                            .animation(Animation.easeOut(duration: 15).repeatForever(autoreverses: true))
                            .shadow(radius: 6)
                            .onAppear(perform: {change = true})
                        
                        Text("\(greatPlant?.name ?? "")")
                            .frame(width: UIScreen.main.bounds.width-10)
                            .scaledToFit()
                            .font(.title)
                            .offset(y: 90)
                        
                        Spacer()
                    }.edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }.edgesIgnoringSafeArea(.top)
            
            ScrollView{
                VStack{
                    VStack{
                        ImageView(for: self.plantImage!)
                            .padding(.top, 60)
                        InfoButtonsView(plantItem: greatPlant!).environment(\.managedObjectContext, self.moc)
                            .padding(.top, 5)
                            .padding(.bottom, 8)
                    }
                    
                    // Watering dates and days since last watering
                    infoFrameView(plantItem: greatPlant!)
                        .padding(.bottom, 5)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 20)
                            .foregroundColor(Color(#colorLiteral(red: 0.311760813, green: 0.7448924184, blue: 0.525581181, alpha: 1)))
                            .shadow(radius: 5)
                            
                        
                        Image(systemName: showNotes ? "chevron.up" : "chevron.down")
                            .resizable()
                            .foregroundColor(Color.themeBackground)
                            .frame(width: 20, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                self.showNotes.toggle()
                            }
                            .animation(.spring())
                    }
                    
                    if showNotes{
                        NotesMenu(plantItem: greatPlant!)
                            .frame(width: 250, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.bottom, 50)
                            .padding(.top, 40)
                    }
                    
                    
                    HStack{
                        Spacer()
                        ZStack{
                            Circle()
                                .frame(width: 34, height: 34)
                                .foregroundColor(Color.themeButtons)
                                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 5)
                                .padding(.trailing, 30)
                            Image(systemName: "gearshape")
                                .foregroundColor(Color.themeBackground)
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    self.showSettings.toggle()
                                })
                                .sheet(isPresented: $showSettings, content: {
                                    changeSettingsView(for: greatPlant!, cat: categories).environment(\.managedObjectContext, self.moc)
                                })
                                .padding(.trailing, 30)
                        }
                    }
                    .animation(.spring())
                    .padding(.top, 5)
                    Spacer()
                }
                .animation(.spring())
                .padding(.bottom, 75)
            }
            .frame(width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.height-90, alignment: .center)
            .scaledToFit()
        }
    }
    
    init(for plant: Plant, cat: categoryHandler){
        if plant.image != nil{
            self.plantImage = Image(uiImage: UIImage(data: plant.image!)!)
        }
        else{
            self.plantImage = Image("cacti")
        }
        
        self.greatPlant = plant
        self.categories = cat
        viewUpdater.givenPlant = plant
    }
}

//struct PlantInfoView_Previews: PreviewProvider {
//    @FetchRequest(entity: Plant.entity(), sortDescriptors: [
//    NSSortDescriptor(keyPath: \Plant.name, ascending: true)]) var plantList: FetchedResults<Plant>
//    @State private var plant: Plant
//
//    let plant = plantList.first
//
//    static var previews: some View {
//
//        PlantInfoView(for: plant)
//    }
//}

struct PlantInfoView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
