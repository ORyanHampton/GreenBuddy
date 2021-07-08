//
//  layeredWaveView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 11/3/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct layeredWaveView: View {
    @State var change = true
    var plantName = ""
    var title = ""
    
    var body: some View {
        VStack{
            ZStack(alignment: .top) {
                WaveShape(yOffset: -0.6)
                    .fill(Color(#colorLiteral(red: 0.3770245515, green: 0.6681438871, blue: 0.2114421766, alpha: 1)))
                    .frame(height: 180)
                    .shadow(radius: 6)
                
                WaveShape(yOffset: 0.7)
                    .fill(Color(#colorLiteral(red: 0.3046105911, green: 0.5444885084, blue: 0.1670262372, alpha: 1)))
                    .frame(height: 200)
                    .shadow(radius: 6)
                
                WaveShape(yOffset: 0.5)
                    .fill(Color.themeWave)
                    .frame(height: 160)
                    .shadow(radius: 6)
                
                if plantName == ""{
                    Text("\(title)")
                        .frame(width: UIScreen.main.bounds.width-10)
                        .scaledToFit()
                        .font(.title)
                        .offset(y: 90)
                }
                else{
                    Text("\(plantName)")
                        .font(.headline)
                        .frame(width: UIScreen.main.bounds.width-10)
                        .scaledToFit()
                        .font(.title)
                        .offset(y: 90)
                }
                
                
                Spacer()
            }.edgesIgnoringSafeArea(.top)
            Spacer()
        }
    }
}

struct layeredWaveView_Previews: PreviewProvider {
    static var previews: some View {
        layeredWaveView()
    }
}
