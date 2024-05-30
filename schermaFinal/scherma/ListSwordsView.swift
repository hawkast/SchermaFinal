import SwiftUI
import AVFAudio

struct ListSwordsView: View {
    @Binding var selectedPhoto: Photo?
    @State private var photos = [
        Photo(title: "Katana", file: "katana", firstAt: "katanaS"),
        Photo(title: "Laser", file: "laserS", firstAt: "laserSS"),
        Photo(title: "Pirate", file: "pirataS", firstAt: "pirataS"),
        Photo(title: "Gladiator", file: "gladiatorS", firstAt: "gladiatorS"),
        Photo(title: "Khight", file: "cavalliereDark", firstAt: "gladiatorS"),
    ]
    @Binding var soundFirst: String
    @Binding var isSelect: Bool
    @State var audioPlayer: AVAudioPlayer!
    @Binding var isSoundOn: Bool
 

    @State private var isSelectedActive = false
    @Environment(\.presentationMode) var presentationMode
    @State private var currentIndex = 0

    var body: some View {
        NavigationView {
            VStack {
                Text(" \(currentIndex + 1) of \(photos.count)")
                    .foregroundStyle(Color(hex: 0x080851))
                    .font(.custom("PoetsenOne-Regular", size: 30))
                    .font(.headline)
                  
                    .padding()
                 //   .background()

                TabView(selection: $currentIndex) {
                    ForEach(photos.indices, id: \.self) { index in
                        VStack {
                            Button(action: {
                              
                                selectedPhoto = photos[index]
                                isSelectedActive = true
                                isSelect = true
                                soundFirst = photos[index].firstAt
                                if isSoundOn{
                                    playSound(sound: soundFirst)
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(photos[index].file)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 300)
                                    .cornerRadius(.infinity)
                            }
                            Text(photos[index].title)
                                .foregroundStyle(Color(hex: 0x080851))
                                .font(.custom("PoetsenOne-Regular", size: 65))
                        }
                       
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 500)
             // .padding()

               // Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xd4dcff))
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Sword")
                        .foregroundStyle(Color(hex: 0x080851))
                        .font(.custom("PoetsenOne-Regular", size: 30))
                        .navigationBarTitleDisplayMode(.inline)
                        .padding(.top, -20)
                }
            }
        }
    }
    func playSound(sound: String) {
        
        let url = Bundle.main.url(forResource: sound, withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer!.play()
    }
}

struct Photo: Identifiable {
    var id = UUID()
    var title: String
    var file: String
    var firstAt: String
    var multiplyRed = 1.0
    var multiplyGreen = 1.0
    var multiplyBlue = 1.0
    var saturation: Double?
    var contrast: Double?
    var original = true
}

struct ListSwordsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListSwordsView(
                selectedPhoto: .constant(Photo(title: "", file: "", firstAt: "")),
                soundFirst: .constant(""),
                isSelect: .constant(true),
                isSoundOn: .constant(true)
            )
        }
    }
}
