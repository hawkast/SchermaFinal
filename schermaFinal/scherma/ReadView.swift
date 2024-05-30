//
//  ReadView.swift
//  ParthenoKitDemo
//
//  Created by Ignazio Finizio on 22/10/2020.
//

import SwiftUI
import ParthenoKit

struct ReadView: View {
    
    @Binding var sTeam: String
    @Binding var sTag: String
    @Binding var sKey: String
    @Binding var sVal: String
    var p: ParthenoKit
    
    var body: some View {
        
        VStack{
            Group{
                Text("Team (*)")
                TextField("Inserisci il nome del tuo team", text: $sTeam)
                    .padding(6)
                    .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .padding(3)
                
                Text("Tag")
                TextField("Inserisci un eventuale tag", text: $sTag)
                    .padding(6)
                    .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .padding(3)
                
                Text("Chiave (*) (usa % per l'elenco di tutte)")
                TextField("Inserisci la chiave univoca associata al valore", text: $sKey)
                    .padding(6)
                    .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .padding(3)
            }
            
            Spacer()
            
            Button(action: {
                 let res = p.readSync(team: sTeam, tag: sTag, key: sKey)
                sVal="\(res)"
            })
            {
                Text("Leggi")
                    .padding(10)
                    .foregroundColor(.white)
            }.background(Color.black)
            Spacer()
            
            Group{
                Spacer()
                Text("Valore")
                 let valore = sVal
                    Text(valore)
                        .padding(6)
                        .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        .padding(3)
                
                
                Spacer()
                Spacer()
                Text("(*) Obbligatorio")
                Spacer()
            }
        }
    }
}
