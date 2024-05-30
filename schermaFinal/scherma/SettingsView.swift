import SwiftUI

struct SettingsView: View {
    @Binding var musics: Bool
    @Binding var isSoundOn: Bool
    @Binding var showSettingsPopup: Bool

    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Toggle(isOn: $musics) {
                        Text("MUSIC")
                            .foregroundStyle(Color(hex: 0x080851))
                            .font(.custom("PoetsenOne-Regular", size: 25))
                            .frame(width: 100, height: 700)
                            .transaction { transaction in
                                transaction.animation = .easeOut(duration: 0.3)
                            }
                    }
                    .padding(.bottom,-40)
                    .toggleStyle(CustomToggleStyle())
                    
                    Toggle(isOn: $isSoundOn) {
                        Text("SOUND")
                            .foregroundStyle(Color(hex: 0x080851))
                            .font(.custom("PoetsenOne-Regular", size: 25))
                            .frame(width: 90, height: 80)
                            .transaction { transaction in
                                transaction.animation = .easeOut(duration: 0.2)
                            }
                    }
                    .padding(.bottom,-40)
                    .toggleStyle(CustomToggleStyle())
                }
                /* .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .background(Color(hex: 0xd4dcff))
                 .ignoresSafeArea()
                 */
                
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("SETTINGS")
                            .font(.custom("PoetsenOne-Regular", size: 30))
                            .navigationBarTitleDisplayMode(.inline)
                            .foregroundStyle(Color(hex: 0x080851))
                    }
                }
                .padding(.top, -350)
                
                
                Button(action: {
                    showSettingsPopup = false
                    if musics {
                        AudioManager.shared.playBackgroundMusic()}
                    else { AudioManager.shared.stopBackgroundMusic()}
                }) {
                    Text("Confirm")
                        .font(.custom("PoetsenOne-Regular", size: 30))
                        .foregroundStyle(Color(hex: 0x080851))
                        .background(
                               RoundedRectangle(cornerRadius: 1)
                                .stroke(Color(hex: 0x080851), lineWidth: 4)
                                .padding(-10))
                    
                    
                }}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xd4dcff))
            .ignoresSafeArea()
        }
       
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? Color.blue : Color.toggleOff)
                .frame(width: 51, height: 31)
                .cornerRadius(16)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(2)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .transaction { transaction in
                            transaction.animation = .easeOut(duration: 0.3)
                        }
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SettingsView(musics: .constant(true), isSoundOn: .constant(true) , showSettingsPopup: .constant(true))
}
//FIELD COMMENTS//
// colori personalizzati oltre ad extension color
// si possono creare nella zona asset e richiamarli, possibile
// scegliere anche per la dark mode come ad esempio
// la creazione ToggleColor
// Color.toggleOff è un colore personalizzato per il toggle light/dark
