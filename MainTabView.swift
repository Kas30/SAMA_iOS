import SwiftUI

/**
 * Main Tab Navigation for iOS Samaa App.
 */
struct MainTabView: View {
    @State private var selectedTab: Int = 0

    init() {
        // Configure iOS TabBar Appearance with Royal Crimson
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.crimsonNavBar)

        // Item Colors
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.antiqueGoldLight)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.antiqueGoldLight)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Home (Prayer times & Dashboard)
            HomePlaceholderView()
                .tabItem {
                    Label("الرئيسية", systemImage: "house.fill")
                }
                .tag(0)

            // Tab 2: Adhkar (19 Morning, 19 Evening, 15 Sleep, 10 Prayer)
            AdhkarHomeView()
                .tabItem {
                    Label("الأذكار", systemImage: "sparkles")
                }
                .tag(1)

            // Tab 3: Qibla Compass
            QiblaCompassView()
                .tabItem {
                    Label("القبلة", systemImage: "safari.fill")
                }
                .tag(2)

            // Tab 4: Calendar & Appointments
            CalendarPlaceholderView()
                .tabItem {
                    Label("التقويم", systemImage: "calendar")
                }
                .tag(3)
        }
    }
}

struct HomePlaceholderView: View {
    var body: some View {
        ZStack {
            Color.royalBeigeBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("سَمَاء")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.crimsonPrimary)
                Text("مواقيت الصلاة، الأذكار، والقبلة")
                    .font(.system(size: 14))
                    .foregroundColor(.mutedEspressoText)
            }
        }
    }
}

struct CalendarPlaceholderView: View {
    var body: some View {
        ZStack {
            Color.royalBeigeBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("التقويم الهجري والمواعيد")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.darkEspressoText)
            }
        }
    }
}

@main
struct SamaaApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.layoutDirection, .rightToLeft) // Right-to-Left for Arabic
        }
    }
}
