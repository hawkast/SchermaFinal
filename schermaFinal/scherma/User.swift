//
//  User.swift
//  scherma
//
//  Created by Roberto Della Corte on 12/05/24.
//

import Foundation
import SwiftUI

class User: ObservableObject {
    @Published var health: Int = 100
    
    // Metodo per infliggere danni all'utente
    func takeDamage(fromAttack attack: Int) {
        // Sottrae i danni dalla vita dell'utente
        health -= attack
        print("L'utente subisce \(attack) danni. Vita rimanente: \(health)")
    }
    
    // Metodo per ripristinare la salute dell'utente
    func restoreHealth() {
        health = 100
        print("La vita dell'utente è stata ripristinata. Vita attuale: \(health)")
    }
}
