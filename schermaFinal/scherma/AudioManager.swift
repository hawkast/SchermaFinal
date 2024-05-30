import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "beyond-horizons-201654", withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // loop infinito
            player?.play()
        } catch {
            print("Errore nella riproduzione della musica: \(error.localizedDescription)")
        }
    }

    func stopBackgroundMusic() {
        player?.stop()
     //   player?.numberOfLoops = 0
    }
}
