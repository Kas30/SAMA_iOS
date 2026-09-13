import SwiftUI

/**
 * Main Overview of Adhkar categories in iOS.
 */
struct AdhkarHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.royalBeigeBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Header Parchment Card
                        AdhkarHeaderParchment()

                        // Category 1: Morning
                        NavigationLink(destination: AdhkarDetailView(category: .morning, allItems: MorningAdhkarData.items)) {
                            AdhkarCategoryRow(
                                title: "أذكار الصباح",
                                subtitle: "أذكار اليوم والبركة والتحصين (١٩ ذكراً)",
                                count: "١٩ ذكراً",
                                iconName: "sun.max.fill"
                            )
                        }

                        // Category 2: Evening
                        NavigationLink(destination: AdhkarDetailView(category: .evening, allItems: EveningAdhkarData.items)) {
                            AdhkarCategoryRow(
                                title: "أذكار المساء",
                                subtitle: "حفظ وراحة وسكينة المساء (١٩ ذكراً)",
                                count: "١٩ ذكراً",
                                iconName: "moon.stars.fill"
                            )
                        }

                        // Category 3: Sleep & Waking
                        NavigationLink(destination: AdhkarDetailView(category: .sleepAndWaking, allItems: SleepAdhkarData.items)) {
                            AdhkarCategoryRow(
                                title: "أذكار النوم والاستيقاظ",
                                subtitle: "أذكار النوم والاستيقاظ وخواتيم آل عمران (١٥ ذكراً)",
                                count: "١٥ ذكراً",
                                iconName: "bed.double.fill"
                            )
                        }

                        // Category 4: After Prayer
                        NavigationLink(destination: AdhkarDetailView(category: .afterPrayer, allItems: AfterPrayerAdhkarData.items)) {
                            AdhkarCategoryRow(
                                title: "أذكار بعد الصلاة",
                                subtitle: "التسبيح والتحميد والاستغفار والدعاء (١٠ أدعية)",
                                count: "١٠ أدعية",
                                iconName: "book.closed.fill"
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AdhkarCategoryRow: View {
    let title: String
    let subtitle: String
    let count: String
    let iconName: String

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.crimsonPrimary, Color.crimsonDark], startPoint: .top, endPoint: .bottom))
                    .frame(width: 48, height: 48)
                    .overlay(Circle().stroke(Color.antiqueGold, lineWidth: 1.2))

                Image(systemName: iconName)
                    .font(.system(size: 20))
                    .foregroundColor(Color.antiqueGoldLight)
            }

            // Title & Subtitle
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.darkEspressoText)

                Text(subtitle)
                    .font(.system(size: 11.5))
                    .foregroundColor(.mutedEspressoText)
                    .lineLimit(2)
            }

            Spacer()

            // Count Badge
            Text(count)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.crimsonPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.royalBeigeCardLight)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.sandBorder, lineWidth: 0.8))

            Image(systemName: "chevron.left")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.antiqueGold)
        }
        .padding(14)
        .background(Color.royalBeigeCard)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.sandBorder, lineWidth: 1))
        .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
    }
}

struct AdhkarHeaderParchment: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("الذِّكْرُ وَالدُّعَاء")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.crimsonPrimary)

                Text("الأذكار اليومية")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.darkEspressoText)

                Text("أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.mutedEspressoText)
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.crimsonPrimary)
                    .frame(width: 52, height: 52)
                    .overlay(Circle().stroke(Color.antiqueGold, lineWidth: 1.5))

                Image(systemName: "sparkles")
                    .font(.system(size: 24))
                    .foregroundColor(Color.antiqueGoldLight)
            }
        }
        .padding(18)
        .background(Color.royalBeigeCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.sandBorder, lineWidth: 1.2))
        .shadow(color: Color.black.opacity(0.06), radius: 6, y: 3)
    }
}
