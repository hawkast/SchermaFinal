//
//  ExtentionColor.swift
//  scherma
//
//  Created by Lorenzo Guerrini on 22/05/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt32){
        let red = Double((hex >> 16) & 0xFF) / 255.0
                         let green = Double((hex >> 8) & 0xFF) / 255.0
                                            let blue = Double(hex & 0xFF) / 255.0
                         self.init(red : red , green: green, blue: blue)
        
    }
    
    
    
    
}
