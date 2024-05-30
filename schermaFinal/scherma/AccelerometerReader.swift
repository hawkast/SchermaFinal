import SwiftUI
import Foundation
import CoreMotion
import UIKit
import AVFoundation
import ParthenoKit

struct AccelerometerReader: View {
    
    let motionManager = CMMotionManager()
    @State var audioPlayer: AVAudioPlayer!
    @State var count = 0
    
    @State private var isDefending = false
    @State private var maxTiltAngleDuringDefense: Double = 0.0
    @State private var showMessage = false
    @Binding var isSoundOn: Bool
    @Binding var soundFirst: String
    
    @Binding var sTeam: String
    @Binding var sTag: String
    @Binding var sKey: String
    @Binding var sVal: String
    @Binding var keyOpponent: String
    var p: ParthenoKit
    
    @State private var attackExecuted = false
    @State private var isWritePerformed = false
    @State private var shouldReadUUID = false
    @ObservedObject private var pollingManager = PollingManager<String>(pollingInterval: 0.3)
    @State var numberOfTimePolled = 0
    
    @State private var lastReadValue: String = ""
    @State private var lastReadValueRead: [String : String] = ["AAAA": "BBB"]
    @State private var lastRandomNumber: Int = 0 // Memorizza l'ultimo numero casuale generato
    @State private var lastAttackTime: Date? // Memorizza l'ora dell'ultimo attacco
    @StateObject var user: User
       @Binding var statisticViewPresented: Bool
    @Binding var attackMade: Int
    @Binding var attackSuffered: Int
    @Binding var gameInProgress: Bool
    @State var endLife: Bool = false
    @State var lastLifesave: String = ""
   
    
    
    @State private var lastDamageTime: Date? = nil
    @Binding var isEnable : Bool
    @Binding var resultB: String 

       
       var body: some View {
           VStack {
               if showMessage {
                   Text("Sei uscito dalla posizione di difesa")
                       .foregroundColor(.red)
               }
               Text("")
                   .onAppear {
                       startAccelerometerUpdates()
                       startMotionUpdates()
                   }
           }
       }
       
       func startAccelerometerUpdates() {
           if motionManager.isAccelerometerAvailable {
               motionManager.accelerometerUpdateInterval = 0.1
               motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                   guard let acceleration = data?.acceleration else {
                       print("Errore nel rilevamento dell'accelerazione: \(error?.localizedDescription ?? "Errore sconosciuto")")
                       return
                   }
                   
                  
                      
                   if acceleration.x > 1.5 || acceleration.y > 1.6{
                       print("ATTACCO: TAGLIO")
                       
                       if let lastAttack = lastAttackTime {
                           let timeInterval = Date().timeIntervalSince(lastAttack)
                           if timeInterval < 1.5 {
                               print("Attacco ignorato, troppo presto dopo l'ultimo attacco")
                               return
                           }
                       }
                       
                       lastAttackTime = Date()
                       
                       if isSoundOn {
                           playSound(sound: soundFirst)
                       }
                     //  UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                       attackExecuted = true
                       handleWrite(attackType: "TAGLIO")
                       attackMade += 1
                       return
                   }
               }
           } else {
               print("L'accelerometro non è disponibile.")
           }
       }
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                guard let attitude = data?.attitude else {
                    print("Errore nel rilevamento dell'atteggiamento: \(error?.localizedDescription ?? "Errore sconosciuto")")
                    return
                }
                handleDefenseLogic(attitude: attitude)
            }
        } else {
            print("Il motion manager non è disponibile")
        }
    }
    
    func handleDefenseLogic(attitude: CMAttitude) {
        handleRead()
    }
    
    func stopAccelerometerUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
            print("Aggiornamenti dell'accelerometro fermati.")
        }
    }
    
    func stopMotionUpdates() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
            print("Aggiornamenti del motion manager fermati.")
        }
    }
    
    func playSound(sound: String) {
        let url = Bundle.main.url(forResource: sound, withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer!.play()
    }
    
    // Funzione per gestire la scrittura
    func handleWrite(attackType: String) {
        //        let time = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "HH:mm:ss.SSS"
        //        let formattedTime = formatter.string(from: time)
        let randomNum = Int.random(in: 0...1000000)
        
        if attackExecuted {
            let valueString = "\(attackType)@\(randomNum)"
            
            let success = p.writeSync(team: sTeam, tag: sTag, key: sKey, value: valueString)
            
            if success {
                print("Scrittura completata con successo")
                isWritePerformed = true
                lastReadValue = valueString // Memorizza l'intera stringa del valore scritto
                lastRandomNumber = randomNum
                shouldReadUUID = true // Segna che ora dovrebbe leggere l'UUID
            } else {
                print("Errore durante l'operazione di scrittura")
            }
            attackExecuted = false
            
        }
    }
    func writeLifePoint(){
        let valueLife = "\(user.health)"
        let succ = p.writeSync(team: sTeam, tag: sTag, key: sKey, value: valueLife)
        if succ {
            print("life inviata con successo")
            lastLifesave = valueLife
        }
    }
    
    
    // Funzione per gestire la lettura
    func handleRead() {
        if !pollingManager.isPolling {
            pollingManager.startPolling {
                self.pollingAction()
            }
        }
    }
    func pollingAction() {
           user.health
           print(user.health)
         
           
           let idlorenzo = keyOpponent
         
               let resultLife = p.readSync(team: sTeam, tag: sTag, key: idlorenzo)
          let index = "\(idlorenzo)"
        if resultLife[index] == "0"{
             
                  resultB = "WIN"
                       statisticViewPresented = true
                       stopRead()
                       stopMotionUpdates()
                       stopAccelerometerUpdates()
                       gameInProgress = false
            playSound(sound: "gameOver")
            user.restoreHealth()
                       
                   
               }
           let result = p.readSync(team: sTeam, tag: sTag, key: idlorenzo)
          // var lastAttack = "\(lastReadValueRead)"
           if result != lastReadValueRead {
            //   print(result)
              let newValue = "\(result)"
               print("STAMPA nEWvALUE\(newValue)")
               
               let components = newValue.split(separator: "@")
               if components.count == 2 {
                   let attackType = String(components[0])
                   let attackID = String(components[1])
                   
                   // Verifica se l'attacco è nuovo
                   if attackID != components[1] {
                       print("non considerato")
                       return
                   }
                   print("Tipo di attacco:", attackType)
                   
                   lastReadValueRead = result
                   attackExecuted = true
                   triggerLongVibration() // Avvia la vibrazione
               }                 }
           print("Polling...")
           numberOfTimePolled += 1
           //life P meessa a 0 per test
           if user.health <= 0 {
               resultB = "LOSE"
               statisticViewPresented = true
               stopRead()
               stopMotionUpdates()
               stopAccelerometerUpdates()
               gameInProgress = false
               endLife = true
               writeLifePoint()
               playSound(sound: "gameOver")
               user.restoreHealth()
             
           }
       }
    
    func stopRead() {
        pollingManager.stopPolling()
    }
    
    // Funzione di difesa basata sull'inclinazione
    func defense() {
        let defenseActivationThreshold: Double = 0.5 // Soglia di inclinazione (in radianti) per attivare la difesa permanente
        
        if let data = motionManager.deviceMotion {
            let tiltAngle = data.attitude.pitch // Angolo di inclinazione rispetto all'asse desiderato
            
            if isDefending {
                // Se il telefono è in posizione di difesa permanente, aggiorna l'angolo massimo di inclinazione
                if tiltAngle > maxTiltAngleDuringDefense {
                    maxTiltAngleDuringDefense = tiltAngle
                }
            }
            
            // Verifica se il telefono è in posizione di difesa permanente
            if abs(tiltAngle) > defenseActivationThreshold {
                isDefending = true
                print("Sono in posizione di difesa permanente!")
                playSound(sound: "defendSound")
                // Vibrazione continua quando in posizione di difesa permanente
                print("Parato")
                
            } else {
                // Verifica l'intervallo di tempo dall'ultimo danno subito
                if let lastDamage = lastDamageTime {
                    let timeInterval = Date().timeIntervalSince(lastDamage)
                    if timeInterval < 1.5 {
                        print("Danno ignorato, troppo presto dopo l'ultimo danno")
                        return
                    }
                }
                
                // Disattiva la difesa permanente quando il telefono è inclinato oltre la soglia
                isDefending = false
                print("Uscito dalla posizione di difesa!")
                print("non parato")
                attackSuffered += 1
                user.takeDamage(fromAttack: 20)
                lastDamageTime = Date() // Aggiorna l'ora dell'ultimo danno subito
            }
        }
    }


    
    func triggerLongVibration() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        
        let vibrationDuration: TimeInterval = 2.0 // Durata della vibrazione in secondi
        let vibrationInterval: TimeInterval = 0.1 // Intervallo tra le vibrazioni in secondi
        
        let numberOfVibrations = Int(vibrationDuration / vibrationInterval)
        
        DispatchQueue.global().async {
            for _ in 0..<numberOfVibrations {
                DispatchQueue.main.async {
                    generator.impactOccurred()
                }
                usleep(useconds_t(vibrationInterval * 1_000)) // Converti l'intervallo in microsecondi
            }
            
            DispatchQueue.main.async {
                defense() // Controlla la difesa dopo la vibrazione
            }
        }
        
        // Resetta la variabile di attacco eseguito dopo la vibrazione
        DispatchQueue.main.asyncAfter(deadline: .now() + vibrationDuration) {
            attackExecuted = false
        }
    }


    
    func sleepSeconds() {
        let pauseDuration: useconds_t = 1_000_000 // 1 secondo in microsecondi
        usleep(pauseDuration)
    }
    
//    func pauseHit(){
//        let pausehit: useconds_t = 1_500_000
//        usleep(pausehit)
//
//    }
}
