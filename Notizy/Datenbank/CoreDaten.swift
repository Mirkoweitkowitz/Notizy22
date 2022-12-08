//
//  CoreDaten.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 07.11.22.
//

import Foundation
import SwiftUI
import CoreLocation

struct CoreDaten: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var adress: String
    var email: String
    var notes: String
    var isFavorite: Bool
    var isFeatured: Bool
    


    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    var featureImage: Image? {
        isFeatured ? Image(imageName + "_feature") : nil
    }

   
    }
  

