import SwiftUI

/**
 * Screen displaying the list of Adhkar cards for a specific category in iOS.
 */
struct AdhkarDetailView: View {
    let category: AdhkarCategory
    let allItems: [DhikrItem]
    
    @Environment(\.presentationMode) var presentationMode

    @State private var showTashkeel: Bool = true
    @State private var fontSizeSp: CGFloat = 17.0
    @State private var searchQuery: String = ""
    @State private var counterMap: [Int: Int] = [:]
    @State private var showCopiedAlert: Bool = false

    var filteredItems: [DhikrItem] {
        if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return allItems
        } else {
            let cleanQuery = DhikrItem.removeArabicDiacritics(searchQuery)
            return allItems.filter { item in
                item.titleWithoutTashkeel.localizedCaseInsensitiveContains(cleanQuery) ||
                item.textWithoutTashkeel.localizedCaseInsensitiveContains(cleanQuery) ||
                (item.virtue.map { DhikrItem.removeArabicDiacritics($0).localizedCaseInsensitiveContains(cleanQuery) } ?? false)
            }
        }
    }

    var body: some View {
        ZStack {
            Color.royalBeigeBackground
                .ignoresSafeArea()

            VStack(spacing: 12) {
                // Header Bar with Back Button and Category Title
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.crimsonPrimary)
                            .padding(10)
                            .background(Color.royalBeigeCard)
                            .clipShape(CircleShape())
                            .overlay(
                                CircleShape()
                                    .stroke(Color.sandBorder, lineWidth: 1)
                            )
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.titleAr)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.darkEspressoText)

                        Text("\(allItems.count) بطاقة دعاء")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.crimsonPrimary)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Sticky Controls Bar (Tashkeel toggle, Font size stepper, Search)
                VStack(spacing: 10) {
                    HStack {
                        // مفتاح التشكيل
                        Toggle(isOn: $showTashkeel) {
                            Text(showTashkeel ? "مُشكّل بالكامل" : "نص بدون تشكيل")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.crimsonPrimary)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .crimsonPrimary))

                        Spacer().frame(width: 16)

                        // أزرار التحكم بحجم الخط
                        HStack(spacing: 6) {
                            Button(action: {
                                if fontSizeSp > 14 { fontSizeSp -= 1 }
                            }) {
                                Text("A-")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.crimsonPrimary)
                                    .frame(width: 32, height: 30)
                                    .background(Color.royalBeigeCardLight)
                                    .cornerRadius(6)
                            }

                            Text("\(Int(fontSizeSp))")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.darkEspressoText)
                                .frame(width: 24)

                            Button(action: {
                                if fontSizeSp < 26 { fontSizeSp += 1 }
                            }) {
                                Text("A+")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.crimsonPrimary)
                                    .frame(width: 32, height: 30)
                                    .background(Color.royalBeigeCardLight)
                                    .cornerRadius(6)
                            }
                        }
                    }

                    // شريط البحث السريع
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.antiqueGold)

                        TextField("ابحث عن أي كلمة في الذكر أو الدعاء...", text: $searchQuery)
                            .font(.system(size: 13))

                        if !searchQuery.isEmpty {
                            Button(action: { searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.royalBeigeCardLight)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.sandBorderMuted, lineWidth: 1)
                    )
                }
                .padding(12)
                .background(Color.royalBeigeCard)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.sandBorder, lineWidth: 1)
                )
                .padding(.horizontal, 16)

                // قائمة البطاقات
                if filteredItems.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "text.magnifyingglass")
                            .font(.system(size: 38))
                            .foregroundColor(.antiqueGold)
                        Text("لا توجد أذكار تطابق نص البحث")
                            .font(.system(size: 14))
                            .foregroundColor(.mutedEspressoText)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, dhikr in
                                DhikrCardView(
                                    dhikr: dhikr,
                                    index: index,
                                    showTashkeel: showTashkeel,
                                    fontSizeSp: fontSizeSp,
                                    currentCount: Binding(
                                        get: { counterMap[dhikr.id] ?? 0 },
                                        set: { counterMap[dhikr.id] = $0 }
                                    ),
                                    onReset: {
                                        counterMap[dhikr.id] = 0
                                    },
                                    onCopy: {
                                        showCopiedAlert = true
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(
            Group {
                if showCopiedAlert {
                    VStack {
                        Spacer()
                        Text("تم نسخ نص الذكر بنجاح")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.crimsonPrimary.opacity(0.95))
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                            .padding(.bottom, 24)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    showCopiedAlert = false
                                }
                            }
                    }
                }
            }
        )
    }
}
