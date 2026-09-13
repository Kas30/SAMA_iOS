import Foundation

/**
 * Model representing an individual Dhikr or Duaa item in iOS.
 */
struct DhikrItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let titleWithoutTashkeel: String
    let textWithTashkeel: String
    let textWithoutTashkeel: String
    let targetRepeatCount: Int
    let virtue: String?
    let note: String?

    init(
        id: Int,
        title: String,
        textWithTashkeel: String,
        targetRepeatCount: Int = 1,
        virtue: String? = null,
        note: String? = null
    ) {
        self.id = id
        self.title = title
        self.titleWithoutTashkeel = DhikrItem.removeArabicDiacritics(title)
        self.textWithTashkeel = textWithTashkeel
        self.textWithoutTashkeel = DhikrItem.removeArabicDiacritics(textWithTashkeel)
        self.targetRepeatCount = targetRepeatCount
        self.virtue = virtue
        self.note = note
    }

    /**
     * Removes Arabic diacritical marks (Tashkeel, Tanween, Shaddah, Sukun, Tatweel).
     */
    static func removeArabicDiacritics(_ text: String) -> String {
        let arabicDiacriticsRegex = "[\\u064B-\\u0652\\u0670\\u0640]"
        return text.replacingOccurrences(
            of: arabicDiacriticsRegex,
            with: "",
            options: .regularExpression
        )
    }
}

enum AdhkarCategory: String, CaseIterable, Identifiable {
    case morning = "morning"
    case evening = "evening"
    case sleepAndWaking = "sleep_and_waking"
    case afterPrayer = "after_prayer"

    var id: String { rawValue }

    var titleAr: String {
        switch self {
        case .morning: return "أذكار الصباح"
        case .evening: return "أذكار المساء"
        case .sleepAndWaking: return "أذكار النوم والاستيقاظ"
        case .afterPrayer: return "أذكار بعد الصلاة"
        }
    }

    var expectedCount: Int {
        switch self {
        case .morning: return 19
        case .evening: return 19
        case .sleepAndWaking: return 15
        case .afterPrayer: return 10
        }
    }

    var subtitleAr: String {
        switch self {
        case .morning: return "أذكار اليوم والبركة والتحصين (١٩ ذكراً)"
        case .evening: return "حفظ وراحة وسكينة المساء (١٩ ذكراً)"
        case .sleepAndWaking: return "أذكار النوم والاستيقاظ وخواتيم آل عمران (١٥ ذكراً)"
        case .afterPrayer: return "التسبيح والتحميد والاستغفار والدعاء (١٠ أدعية)"
        }
    }

    var iconSystemName: String {
        switch self {
        case .morning: return "sun.max.fill"
        case .evening: return "moon.stars.fill"
        case .sleepAndWaking: return "bed.double.fill"
        case .afterPrayer: return "book.closed.fill"
        }
    }
}
