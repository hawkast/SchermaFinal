import Foundation
import SwiftUI
import ParthenoKit
import Security

struct FightPage: View {
    @AppStorage("isSoundOn") private var isSoundOn = true
    @AppStorage("soundFirst") private var soundFirst: String = ""
    
    @State var sTeam = "TeamA2122S678QD"
    @State var sTag = "scherma"
    @State var sKey = ""
    @State var sVal = ""
    @State var sName = ""
    @State var keyOpponent = ""
    @State var result: [String: String] = [:]
    var p = ParthenoKit()
    @State var numberKeyR: Int = 0
    @State var noEmpty: Bool = false
    @State var isEnabled: Bool = false
    @State private var accelerometerReaderIsRunning = false
    @State var user = User()
    @State var statisticViewPresented: Bool = false
    @State var suffered: Int = 0
    @State var made: Int = 0
    @State var disableText: Bool = true
    @State var gameInProgress: Bool = false
 
    @State var resultB: String = ""
    
    @FocusState private var isTextFieldFocused: Bool // Aggiunta per gestire il focus delle text field
    
    var body: some View {
        
        let accelerometerReader = AccelerometerReader(
            isSoundOn: $isSoundOn,
            soundFirst: $soundFirst,
            sTeam: $sTeam,
            sTag: $sTag,
            sKey: $sKey,
            sVal: $sVal,
            keyOpponent: $keyOpponent,
            p: p,
            user: user,
            statisticViewPresented: $statisticViewPresented,
            attackMade: $made,
            attackSuffered: $suffered,
            gameInProgress: $gameInProgress,
            isEnable: $isEnabled,
            resultB: $resultB
            
            
            
        )
        
        
       
            NavigationView {
                ZStack {
                    VStack {
                        
                        HStack {
                            Button("Generate ") {
                                sKey = generateUuid()
                            }
                            .foregroundColor(Color(hex: 0x080851))
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.toggleOff.opacity(0.2)))
                            .frame(width: 100, height: 60)
                            
                            TextField("Insert your key", text: $sKey)
                                .onChange(of: sKey, initial: false) { _, _ in
                                    updateIsKeyEntered()
                                }
                                .foregroundColor(Color(hex: 0x080851))
                                .frame(width: 200, height: 40.0)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.textField.opacity(0.2)))
                                .disabled(true) // Per evitare modifiche manuali
                                .focused($isTextFieldFocused)
                            
                        }
                        .padding(.trailing, 85)
                        
                        TextField("insert avversary's key", text: $keyOpponent)
                            .keyboardType(.numberPad)
                            .onChange(of: keyOpponent, initial: false) { _, _ in
                                updateIsKeyEntered()
                            }
                            .frame(width: 200, height: 40)
                            .foregroundColor(Color(hex: 0x080851))
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.textField.opacity(0.2)))
                            .focused($isTextFieldFocused) // Gestisce il focus
                        
                        Button("Start Game") {
                            noEmpty = true
                            connectToGame()
                            disableText = false
                            gameInProgress = true
                            isTextFieldFocused = false // Rimuove il focus dalle text field
                        }
                        .frame(width: 100.0, height: 50.0)
                        .disabled(!isEnabled)
                        .foregroundColor(Color(hex: 0x080851))
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.toggleOff.opacity(0.2)))
                        .disabled(!disableText)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("FightPage")
                                    .font(.custom("PoetsenOne-Regular", size: 30))
                                    .navigationBarTitleDisplayMode(.inline)
                                    .foregroundStyle(Color(hex: 0x080851))
                            }
                        }
                        
                        if accelerometerReaderIsRunning {
                            accelerometerReader
                                .onDisappear {
                                    accelerometerReader.stopAccelerometerUpdates()
                                    accelerometerReader.stopMotionUpdates()
                                    accelerometerReader.stopRead()
                                }
                        }
                        
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: 0xd4dcff))
                    .ignoresSafeArea()
                    .onAppear {
                        AudioManager.shared.stopBackgroundMusic()
                    }
                    .sheet(isPresented: $statisticViewPresented) {
                        StatisticView(suffered: $suffered, made: $made, resultB: $resultB)
                    }
                    
                    if gameInProgress {
                        Color.black
                            .ignoresSafeArea()
                            .transition(.opacity)
                    }
                }
            }
    }
    
    func generateUuid() -> String {
        numberKeyR = Int.random(in: 0...100000)
        let stringValue = String(numberKeyR)
        return stringValue
    }
    
    func connectToGame() {
        // Qui potresti inserire ulteriori controlli prima di avviare AccelerometerReader
        if noEmpty {
            accelerometerReaderIsRunning = true
        }
    }
    
    private func updateIsKeyEntered() {
        if !sKey.isEmpty && !keyOpponent.isEmpty {
            isEnabled = true
        } else {
            isEnabled = false
        }
    }
    
    static func getUUID() -> String {
        getKeychainUUID() ?? saveAndReturnUUID()
    }
    
    static func getKeychainUUID() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "UUID",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        return status == errSecSuccess ? (item as? Data).flatMap { String(data: $0, encoding: .utf8) } : nil
    }
    
    static func saveAndReturnUUID() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        saveKeychainUUID(uuid: uuid)
        return uuid
    }
    
    static func saveKeychainUUID(uuid: String) {
        let data = uuid.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "UUID",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary) // Delete any existing item
        SecItemAdd(query as CFDictionary, nil)
    }
}

#Preview {
    FightPage()
}
