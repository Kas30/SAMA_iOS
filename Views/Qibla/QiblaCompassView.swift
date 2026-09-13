import SwiftUI
import CoreLocation

/**
 * Interactive Qibla Compass for iOS using CoreLocation.
 */
struct QiblaCompassView: View {
    @StateObject private var compassManager = CompassManager()

    var body: some View {
        ZStack {
            Color.royalBeigeBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Text("اتجاه القبلة المشرفة")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.darkEspressoText)

                    Text("مكة المكرمة • الكعبة المشرفة")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.mutedEspressoText)
                }
                .padding(.top, 16)

                Spacer()

                // Compass Dial
                ZStack {
                    // Outer Ornate Ring
                    Circle()
                        .stroke(Color.antiqueGold.opacity(0.4), lineWidth: 3)
                        .frame(width: 290, height: 290)

                    Circle()
                        .fill(Color.royalBeigeCard)
                        .frame(width: 270, height: 270)
                        .overlay(Circle().stroke(Color.antiqueGold, lineWidth: 1.5))
                        .shadow(color: Color.black.opacity(0.08), radius: 10, y: 5)

                    // Compass Rose & Degrees
                    ForEach(0..<12) { i in
                        Rectangle()
                            .fill(Color.antiqueGold.opacity(i % 3 == 0 ? 0.9 : 0.4))
                            .frame(width: i % 3 == 0 ? 3 : 1.5, height: i % 3 == 0 ? 14 : 8)
                            .offset(y: -120)
                            .rotationEffect(.degrees(Double(i) * 30))
                    }

                    // Rotating Compass Needle
                    ZStack {
                        // Kaaba Direction Marker
                        VStack {
                            Image(systemName: "location.north.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.crimsonPrimary)
                            Spacer().frame(height: 110)
                        }

                        // Gold Pivot
                        Circle()
                            .fill(Color.antiqueGold)
                            .frame(width: 20, height: 20)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                    .rotationEffect(.degrees(compassManager.qiblaAngle))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: compassManager.qiblaAngle)
                }

                Spacer()

                // Bottom Status Pill
                HStack(spacing: 12) {
                    Image(systemName: "safari.fill")
                        .foregroundColor(.crimsonPrimary)

                    Text(String(format: "زاوية القبلة: %.1f°", compassManager.qiblaBearing))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.darkEspressoText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.royalBeigeCard)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.sandBorder, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                .padding(.bottom, 32)
            }
        }
    }
}

class CompassManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var qiblaAngle: Double = 0.0
    @Published var qiblaBearing: Double = 136.5 // Default Kaaba bearing for Riyadh

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        self.qiblaAngle = qiblaBearing - heading
    }
}
