//
//  ImageGallaryView.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/14/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct ImageGallaryView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image(systemName: "plus").onTapGesture(perform: {
                    
                })
                .padding(30)
            }
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(0 ..< 4){ number in
                        HStack{
                            ForEach(0 ..< 3){ object in
                                Image("cacti")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
                .padding(.trailing, 12.0)
                .padding(.top, 15)
                .frame(width: 400.0)
            }
        }
    }
    
//    init(for plantGallary: Image){
//        plantImage = plantGallary
//    }
}

struct ImageGallaryView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGallaryView()
    }
}
