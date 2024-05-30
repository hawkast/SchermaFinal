//
//  SettingState.swift
//  scherma
//
//  Created by Lorenzo Guerrini on 16/05/24.
//

import Foundation

import Combine

class SettingState: ObservableObject {
    @Published var isSoundOn: Bool = true
}
