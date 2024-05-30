import SwiftUI
import CoreMotion

struct TestFile: View {
    @State private var isRecording = false
    @State private var motionDataArray = [(Double, Double, Double)]()
    @State private var hasCut = false
    
    let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Button(action: {
                self.startRecording()
            }) {
                Text("Registra Movimento")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Button(action: {
                self.stopRecording()
            }) {
                Text("Ferma Registrazione")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if hasCut {
                Text("Taglio eseguito!")
                    .foregroundColor(.green)
                    .padding()
            } else {
                Text("Nessun taglio rilevato.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
    
    func startRecording() {
        print("Registrazione avviata. Esegui il movimento desiderato.")
        motionDataArray.removeAll()
        hasCut = false
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let motionData = data {
                    let acceleration = motionData.userAcceleration
                    let xAcceleration = acceleration.x
                    let yAcceleration = acceleration.y
                    let zAcceleration = acceleration.z
                    self.motionDataArray.append((xAcceleration, yAcceleration, zAcceleration))
                }
            }
        } else {
            print("Accelerometro e/o giroscopio non disponibili.")
        }
    }
    
    func stopRecording() {
        print("Registrazione fermata.")
        motionManager.stopDeviceMotionUpdates()
        
        if motionDataArray.count < 2 {
            print("Nessun dato sufficiente per rilevare il taglio.")
            return
        }
        
        let initialYAcceleration = motionDataArray.first!.1
        let finalYAcceleration = motionDataArray.last!.1
        
        let accelerationDifference = initialYAcceleration - finalYAcceleration
        
        if accelerationDifference > 3.0 {
            hasCut = true
        }
    }
}

struct TestPrev: PreviewProvider {
    static var previews: some View {
        TestFile()
    }
}
