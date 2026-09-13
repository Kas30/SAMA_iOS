import Foundation

/**
 * Calculation methods for prayer times in iOS, matching Android CalculationMethod.
 */
public enum CalculationMethod: String, CaseIterable, Identifiable {
    case ummAlQura = "UMM_AL_QURA"
    case muslimWorldLeague = "MUSLIM_WORLD_LEAGUE"
    case egyptianGeneralAuthority = "EGYPTIAN"
    case karachi = "KARACHI"
    case northAmerica = "ISNA"
    case kuwait = "KUWAIT"
    case qatar = "QATAR"
    case dubai = "DUBAI"
    case custom = "CUSTOM"

    public var id: String { rawValue }

    public var displayNameAr: String {
        switch self {
        case .ummAlQura: return "أم القرى (مكة المكرمة)"
        case .muslimWorldLeague: return "رابطة العالم الإسلامي"
        case .egyptianGeneralAuthority: return "الهيئة المصرية العامة للمساحة"
        case .karachi: return "جامعة العلوم الإسلامية بكراتشي"
        case .northAmerica: return "الجمعية الإسلامية لأمريكا الشمالية (ISNA)"
        case .kuwait: return "وزارة الأوقاف والشؤون الإسلامية بالكويت"
        case .qatar: return "وزارة الأوقاف والشؤون الإسلامية بقطر"
        case .dubai: return "دبي والشؤون الإسلامية بالإمارات"
        case .custom: return "طريقة مخصصة يدوياً"
        }
    }

    public var fajrAngle: Double {
        switch self {
        case .ummAlQura: return 18.5
        case .muslimWorldLeague: return 18.0
        case .egyptianGeneralAuthority: return 19.5
        case .karachi: return 18.0
        case .northAmerica: return 15.0
        case .kuwait: return 18.0
        case .qatar: return 18.0
        case .dubai: return 18.2
        case .custom: return 18.5
        }
    }

    public var ishaAngle: Double {
        switch self {
        case .ummAlQura, .qatar: return 0.0 // Uses interval
        case .muslimWorldLeague: return 17.0
        case .egyptianGeneralAuthority: return 17.5
        case .karachi: return 18.0
        case .northAmerica: return 15.0
        case .kuwait: return 17.5
        case .dubai: return 18.2
        case .custom: return 0.0
        }
    }

    public var ishaIntervalMinutes: Int {
        switch self {
        case .ummAlQura: return 90
        case .qatar: return 90
        default: return 0
        }
    }
}

public enum AsrMethod: String, CaseIterable, Identifiable {
    case standard = "STANDARD" // Shafi'i, Maliki, Hanbali
    case hanafi = "HANAFI"

    public var id: String { rawValue }

    public var displayNameAr: String {
        switch self {
        case .standard: return "الجمهور (الشافعي، المالكي، الحنبلي - مثل الظل)"
        case .hanafi: return "الحنفي (مثلي الظل)"
        }
    }

    public var shadowRatio: Double {
        switch self {
        case .standard: return 1.0
        case .hanafi: return 2.0
        }
    }
}

public enum HighLatitudeRule: String, CaseIterable, Identifiable {
    case middleOfTheNight = "MIDDLE_OF_NIGHT"
    case oneSeventh = "ONE_SEVENTH"
    case angleBased = "ANGLE_BASED"
    case none = "NONE"

    public var id: String { rawValue }

    public var displayNameAr: String {
        switch self {
        case .middleOfTheNight: return "نصف الليل"
        case .oneSeventh: return "سبع الليل"
        case .angleBased: return "نسبة زاوية الفلك"
        case .none: return "تعطيل القاعدة"
        }
    }
}
