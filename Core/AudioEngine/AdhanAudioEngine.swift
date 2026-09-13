import Foundation
import AVFoundation

/**
 * Adhan sound item for iOS matching the 17 audio tones.
 */
public struct AdhanSoundOption: Identifiable, Hashable {
    public let id: String
    public let titleAr: String
    public let fileName: String
    public let isFajrExclusive: Bool

    public init(id: String, titleAr: String, fileName: String, isFajrExclusive: Bool = false) {
        self.id = id
        self.titleAr = titleAr
        self.fileName = fileName
        self.isFajrExclusive = isFajrExclusive
    }
}

public class AdhanAudioCatalog {
    public static let shared = AdhanAudioCatalog()

    public let allSounds: [AdhanSoundOption] = [
        AdhanSoundOption(id: "adhan_hamad_aldughairiri", titleAr: "أذان حمد الدغريري (جامع الراجحي بالرياض)", fileName: "adhan_hamad_aldughairiri"),
        AdhanSoundOption(id: "adhan_atif_mulla", titleAr: "أذان عاطف ملا (المسجد الحرام بمكة)", fileName: "adhan_atif_mulla"),
        AdhanSoundOption(id: "adhan_ahmad_mulla", titleAr: "أذان أحمد ملا (شيخ مؤذني الحرم المكي)", fileName: "adhan_ahmad_mulla"),
        AdhanSoundOption(id: "adhan_fajr_mishary_alafasy", titleAr: "أذان الفجر - مشاري العفاسي", fileName: "adhan_fajr_mishary_alafasy", isFajrExclusive: true),
        AdhanSoundOption(id: "adhan_fajr_ibrahim_jabr", titleAr: "أذان الفجر - إبراهيم جبر", fileName: "adhan_fajr_ibrahim_jabr", isFajrExclusive: true),
        AdhanSoundOption(id: "adhan_fajr_issam_bukhari", titleAr: "أذان الفجر - عصام بخاري", fileName: "adhan_fajr_issam_bukhari", isFajrExclusive: true),
        AdhanSoundOption(id: "adhan_fajr_osama_alakhdar", titleAr: "أذان الفجر - أسامة الأخضر", fileName: "adhan_fajr_osama_alakhdar", isFajrExclusive: true),
        AdhanSoundOption(id: "adhan_ahmad_hadrawi", titleAr: "أذان أحمد بن هداري (المسجد النبوي)", fileName: "adhan_ahmad_hadrawi"),
        AdhanSoundOption(id: "adhan_ahmad_khojah", titleAr: "أذان أحمد خوجة (المسجد الحرام)", fileName: "adhan_ahmad_khojah"),
        AdhanSoundOption(id: "adhan_mohammed_almaghrabi", titleAr: "أذان محمد مغربي (المسجد الحرام)", fileName: "adhan_mohammed_almaghrabi"),
        AdhanSoundOption(id: "adhan_saad_faqih", titleAr: "أذان سعد فقيه", fileName: "adhan_saad_faqih"),
        AdhanSoundOption(id: "adhan_abdulmajeed_alsuraihi", titleAr: "أذان عبد المجيد السريحي (المسجد النبوي)", fileName: "adhan_abdulmajeed_alsuraihi"),
        AdhanSoundOption(id: "adhan_omar_sunbul", titleAr: "أذان عمر سنبل (المسجد النبوي)", fileName: "adhan_omar_sunbul"),
        AdhanSoundOption(id: "adhan_iyad_shukri", titleAr: "أذان إياد شكري (المسجد النبوي)", fileName: "adhan_iyad_shukri"),
        AdhanSoundOption(id: "adhan_saud_bukhari", titleAr: "أذان سعود بخاري (المسجد النبوي)", fileName: "adhan_saud_bukhari"),
        AdhanSoundOption(id: "adhan_mansour_alzahrani", titleAr: "أذان منصور الزهراني", fileName: "adhan_mansour_alzahrani"),
        AdhanSoundOption(id: "adhan_nasser_alqatami", titleAr: "أذان ناصر القطامي", fileName: "adhan_nasser_alqatami"),
    ]

    public func generalSounds() -> [AdhanSoundOption] {
        allSounds.filter { !$0.isFajrExclusive }
    }

    public func fajrSounds() -> [AdhanSoundOption] {
        allSounds
    }
}

/**
 * Native iOS AVAudioPlayer manager for Adhan with background audio support.
 */
public class AdhanAudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    public static let shared = AdhanAudioPlayerManager()

    @Published public var currentlyPlayingId: String? = nil
    private var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
    }

    public func togglePlay(sound: AdhanSoundOption) {
        if currentlyPlayingId == sound.id {
            stop()
        } else {
            play(sound: sound)
        }
    }

    public func play(sound: AdhanSoundOption) {
        stop()

        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") ??
              Bundle.main.url(forResource: "Resources/Audio/\(sound.fileName)", withExtension: "mp3") else {
            print("Sound file not found: \(sound.fileName).mp3")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            currentlyPlayingId = sound.id
        } catch {
            print("Error playing audio: \(error)")
            stop()
        }
    }

    public func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentlyPlayingId = nil
    }

    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentlyPlayingId = nil
    }
}
