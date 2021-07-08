//
//  NotesMenu.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 2/8/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct NotesMenu: View {
    let plantItem : Plant
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 350, height: 225)
                .overlay(RoundedRectangle(cornerRadius: 20))
                .foregroundColor(Color(#colorLiteral(red: 0.968095243, green: 0.9484168887, blue: 0.901052177, alpha: 1)))
                .shadow(radius: 5)
            
            VStack{
                VStack(alignment: .leading){
                    Text("Notes")
                        .foregroundColor(.black)
                }
                Text(plantItem.notes ?? "No Notes Found.")
                    .frame(width: 320, height: 170)
                    .foregroundColor(.black)
            }
        }
    }
}

struct NotesMenu_Previews: PreviewProvider {
    static var previews: some View {
//        NotesMenu(plantItem: nil)
        Text("100 days")
    }
}
