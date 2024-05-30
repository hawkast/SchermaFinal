import SwiftUI

struct ContentView: View {
    @State private var showSettingsPopup = false
    @State private var selectedPhoto: Photo?
    @AppStorage("isSoundOn") private var isSoundOn = true
    @AppStorage("musics") private var musics = true {
        didSet {
            if musics {
                AudioManager.shared.playBackgroundMusic()
            } else {
                AudioManager.shared.stopBackgroundMusic()
            }
        }
    }
    @AppStorage("soundFirst") private var soundFirst: String = ""
    @State private var isSelect = false
    @State private var showAl = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 26) {
                Image("logoOriginal")
                   
                                    .resizable()
                                    .aspectRatio(contentMode: .fill )
                                    .frame(width: 400, height: 400, alignment: .trailing)
                                    .padding(.top, -200)
                                    .padding(.leading, 50.0)
              
                NavigationLink(destination: FightPage()) {
                    HStack {
                        Image(systemName: "arrowtriangle.right.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(hex: 0x080851))
                            .transaction { transaction in
                                transaction.animation = .easeOut(duration: 0.3)
                            }
                        Text("FIGHT")
                            .font(.custom("PoetsenOne-Regular", size: 25))
                
                            .foregroundStyle(Color(hex: 0x080851))
                            .transaction { transaction in
                                transaction.animation = .easeOut(duration: 0.50)
                            }
                        
                    }
                    .background(
                           RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: 0x080851), lineWidth: 4)
                            .padding(-10))
                   
                    
                }
                //Gestire il tasto figth con boolean
                .disabled(!isSelect)
                .onTapGesture {
                    if !isSelect {
                        showAl = true
                    }
                }
                
                NavigationLink(destination: ListSwordsView(selectedPhoto: $selectedPhoto, soundFirst: $soundFirst, isSelect: $isSelect, isSoundOn: $isSoundOn)) {
                    HStack {
                        Image(systemName: "figure.fencing")
                            .resizable()
                            .imageScale(.large)
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(hex: 0x080851))
                            .transaction { transaction in
                                transaction.animation = .easeOut(duration: 0.3)
                            }
                        Text("SWORDS")
                            .font(.custom("PoetsenOne-Regular", size: 25))
                            .foregroundStyle(Color(hex: 0x080851))
                            .transaction { transaction in
                                transaction.animation = .easeOut(duration: 0.50)
                            }
                    }
                    .background(
                           RoundedRectangle(cornerRadius: 1)
                            .stroke(Color(hex: 0x080851), lineWidth: 4)
                            .padding(-10))
                }
                
                if let selectedPhoto = selectedPhoto {
                    Image(selectedPhoto.file)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .cornerRadius(.infinity)
                        .padding(.top, 10)
                       
                } else {
                    Text("No sword selected.")
                        .foregroundStyle(Color(hex: 0x080851))
                        .padding(.top, 100)
                        .font(.custom("PoetsenOne-Regular", size: 15))
                       
                }
            }
            //Creare e gestire il background con colori personalizzati
            //presi dal file extensionColor
            .padding(.top, 250)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xd4dcff))
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettingsPopup = true
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color(hex: 0x080851))
                    }
                }
            }
            .overlay(
                Group {
                    if showAl {
                        CustomAlertView(showAl: $showAl)
                    }
                }
            )
            .onAppear {
                if musics {
                    AudioManager.shared.playBackgroundMusic()
                } else {
                    AudioManager.shared.stopBackgroundMusic()
                }
            }
            .sheet(isPresented: $showSettingsPopup) {
                SettingsView(musics: $musics, isSoundOn: $isSoundOn, showSettingsPopup: $showSettingsPopup)
            }
        }
      
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomAlertView: View {
    @Binding var showAl: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Brave! But you need a sword.")
                    .font(.custom("PoetsenOne-Regular", size: 20))
                    .foregroundColor(.white)
                Text("Select a sword before proceeding.")
                    .font(.custom("PoetsenOne-Regular", size: 16))
                    .foregroundColor(.white)
                Button(action: {
                    showAl = false
                }) {
                    Text("OK")
                        .font(.custom("PoetsenOne-Regular", size: 18))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}
