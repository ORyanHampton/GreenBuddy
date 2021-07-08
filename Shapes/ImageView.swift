//
//  ImageView.swift
//  PlantTracker
//
//  Created by O'Ryan Hampton on 10/8/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var gallaryViewIsShowing = false
    @State private var selectedImage: UIImage?
    var plantImage : Image
    
    var body: some View {
        self.plantImage
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200, alignment: .center)
//            .background(Color.clear)
            .clipShape(Circle())
            .shadow(radius: 5)
    }
    
    init(for greenImage: Image){
        self.plantImage = greenImage
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(for: Image("cacti"))
    }
}
