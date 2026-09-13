import Foundation

/**
 * Astronomical Solar Calculation Engine in pure Swift matching Android AstronomicalPrayerCalculator 1:1.
 * Accurately calculates solar declination, transit noon, and Islamic prayer angles.
 */
public struct PrayerTimesResult {
    public let fajr: Date
    public let sunrise: Date
    public let dhuhr: Date
    public let asr: Date
    public let sunset: Date
    public let maghrib: Date
    public let isha: Date
    public let midnight: Date
    public let lastThird: Date
}

public class AstronomicalPrayerCalculator {
    public static let shared = AstronomicalPrayerCalculator()

    public init() {}

    public func calculate(
        date: Date,
        latitude: Double,
        longitude: Double,
        timeZone: TimeZone = .current,
        method: CalculationMethod = .ummAlQura,
        asrMethod: AsrMethod = .standard,
        highLatitudeRule: HighLatitudeRule = .middleOfTheNight
    ) -> PrayerTimesResult? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else {
            return nil
        }

        // 1. Julian Day at 00:00 UTC
        let jd = julianDay(year: year, month: month, day: day)

        // 2. Solar coordinates (Declination and Equation of Time)
        let solar = calculateSolarCoordinates(julianDay: jd)
        let declination = solar.declination
        let eqTime = solar.equationOfTime // minutes

        // 3. Solar Transit (Noon in UTC hours)
        let noonUtcHours = 12.0 - (longitude / 15.0) - (eqTime / 60.0)

        // 4. Sunrise & Sunset angles (-0.8333 degrees)
        let sunAltSunriseSunset = -0.8333
        guard let halfDayHours = hourAngle(lat: latitude, decl: declination, alt: sunAltSunriseSunset) else {
            return nil
        }

        let sunriseUtc = noonUtcHours - halfDayHours
        let sunsetUtc = noonUtcHours + halfDayHours

        // 5. Asr calculation
        let asrAngle = calculateAsrAngle(lat: latitude, decl: declination, shadowRatio: asrMethod.shadowRatio)
        let asrDuration = hourAngle(lat: latitude, decl: declination, alt: asrAngle) ?? (halfDayHours * 0.6)
        let asrUtc = noonUtcHours + asrDuration

        // 6. Fajr calculation
        let rawFajrDuration = hourAngle(lat: latitude, decl: declination, alt: -method.fajrAngle)
        let fajrUtc: Double
        if let dur = rawFajrDuration {
            fajrUtc = applyHighLatitude(requestedTime: noonUtcHours - dur, sunrise: sunriseUtc, sunset: sunsetUtc, rule: highLatitudeRule, angle: method.fajrAngle, isFajr: true)
        } else {
            fajrUtc = applyHighLatitude(requestedTime: sunriseUtc - 1.5, sunrise: sunriseUtc, sunset: sunsetUtc, rule: highLatitudeRule, angle: method.fajrAngle, isFajr: true)
        }

        // 7. Maghrib
        let maghribUtc = sunsetUtc

        // 8. Isha
        let ishaUtc: Double
        if method.ishaIntervalMinutes > 0 {
            ishaUtc = maghribUtc + (Double(method.ishaIntervalMinutes) / 60.0)
        } else {
            let rawIshaDur = hourAngle(lat: latitude, decl: declination, alt: -method.ishaAngle)
            if let dur = rawIshaDur {
                ishaUtc = applyHighLatitude(requestedTime: noonUtcHours + dur, sunrise: sunriseUtc, sunset: sunsetUtc, rule: highLatitudeRule, angle: method.ishaAngle, isFajr: false)
            } else {
                ishaUtc = applyHighLatitude(requestedTime: sunsetUtc + 1.5, sunrise: sunriseUtc, sunset: sunsetUtc, rule: highLatitudeRule, angle: method.ishaAngle, isFajr: false)
            }
        }

        // 9. Midnight & Last Third (Islamic midnight: halfway from Maghrib to next day's Fajr)
        let nightDuration = 24.0 - (maghribUtc - fajrUtc)
        let midnightUtc = maghribUtc + (nightDuration / 2.0)
        let lastThirdUtc = maghribUtc + (nightDuration * (2.0 / 3.0))

        guard let baseMidnight = calendar.date(from: components) else { return nil }
        let tzOffsetSeconds = Double(timeZone.secondsFromGMT(for: baseMidnight))
        let tzOffsetHours = tzOffsetSeconds / 3600.0

        func toDate(utcHours: Double) -> Date {
            let localSeconds = (utcHours * 3600.0)
            return baseMidnight.addingTimeInterval(localSeconds + tzOffsetSeconds)
        }

        return PrayerTimesResult(
            fajr: toDate(utcHours: fajrUtc),
            sunrise: toDate(utcHours: sunriseUtc),
            dhuhr: toDate(utcHours: noonUtcHours),
            asr: toDate(utcHours: asrUtc),
            sunset: toDate(utcHours: sunsetUtc),
            maghrib: toDate(utcHours: maghribUtc),
            isha: toDate(utcHours: ishaUtc),
            midnight: toDate(utcHours: midnightUtc),
            lastThird: toDate(utcHours: lastThirdUtc)
        )
    }

    private func julianDay(year: Int, month: Int, day: Int) -> Double {
        var y = Double(year)
        var m = Double(month)
        let b: Double
        if m <= 2 {
            y -= 1
            m += 12
        }
        let a = floor(y / 100.0)
        b = 2 - a + floor(a / 4.0)
        return floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + Double(day) + b - 1524.5
    }

    private struct SolarCoordinates {
        let declination: Double
        let equationOfTime: Double
    }

    private func calculateSolarCoordinates(julianDay: Double) -> SolarCoordinates {
        let d = julianDay - 2451545.0
        let g = fixAngle(357.529 + 0.98560028 * d)
        let q = fixAngle(280.459 + 0.98564736 * d)
        let l = fixAngle(q + 1.915 * sin(degToRad(g)) + 0.020 * sin(degToRad(2 * g)))
        let e = 23.439 - 0.00000036 * d
        let dd = radToDeg(asin(sin(degToRad(e)) * sin(degToRad(l))))
        var ra = radToDeg(atan2(cos(degToRad(e)) * sin(degToRad(l)), cos(degToRad(l)))) / 15.0
        ra = fixHour(ra)
        let eq = (q / 15.0) - ra
        return SolarCoordinates(declination: dd, equationOfTime: eq * 60.0)
    }

    private func hourAngle(lat: Double, decl: Double, alt: Double) -> Double? {
        let latR = degToRad(lat)
        let declR = degToRad(decl)
        let altR = degToRad(alt)
        let cosHA = (sin(altR) - sin(latR) * sin(declR)) / (cos(latR) * cos(declR))
        if cosHA < -1.0 || cosHA > 1.0 {
            return nil
        }
        return radToDeg(acos(cosHA)) / 15.0
    }

    private func calculateAsrAngle(lat: Double, decl: Double, shadowRatio: Double) -> Double {
        let d = shadowRatio + tan(degToRad(abs(lat - decl)))
        return radToDeg(atan(1.0 / d))
    }

    private func applyHighLatitude(requestedTime: Double, sunrise: Double, sunset: Double, rule: HighLatitudeRule, angle: Double, isFajr: Bool) -> Double {
        let night = 24.0 - (sunset - sunrise)
        let portion: Double
        switch rule {
        case .middleOfTheNight: portion = 0.5
        case .oneSeventh: portion = 1.0 / 7.0
        case .angleBased: portion = angle / 60.0
        case .none: return requestedTime
        }
        let maxTime = portion * night
        if isFajr {
            let diff = sunrise - requestedTime
            if diff > maxTime { return sunrise - maxTime }
        } else {
            let diff = requestedTime - sunset
            if diff > maxTime { return sunset + maxTime }
        }
        return requestedTime
    }

    private func degToRad(_ d: Double) -> Double { d * .pi / 180.0 }
    private func radToDeg(_ r: Double) -> Double { r * 180.0 / .pi }
    private func fixAngle(_ a: Double) -> Double {
        var res = a.truncatingRemainder(dividingBy: 360.0)
        if res < 0 { res += 360.0 }
        return res
    }
    private func fixHour(_ h: Double) -> Double {
        var res = h.truncatingRemainder(dividingBy: 24.0)
        if res < 0 { res += 24.0 }
        return res
    }
}
