//
//  NavigationState.swift
//  scherma
//
//  Created by Lorenzo Guerrini on 20/05/24.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    @Published var currentView: ViewType = .content
    
    enum ViewType {
        case content
        case fight
        case swords
        case settings
        case statistic
    }
}
