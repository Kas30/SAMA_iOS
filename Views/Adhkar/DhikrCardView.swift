import SwiftUI

/**
 * Luxury Islamic Dhikr Card for iOS SwiftUI.
 *
 * Implements the requested bottom deck:
 * [Compact Tasbeeh Button] (Right)
 * [Long Progress Bar] (Center)
 * [Reset on Top, Counter at Bottom] (Far Left)
 */
struct DhikrCardView: View {
    let dhikr: DhikrItem
    let index: Int
    let showTashkeel: Bool
    let fontSizeSp: CGFloat
    
    @Binding var currentCount: Int
    let onReset: () -> Void
    let onCopy: () -> Void

    var targetCount: Int { dhikr.targetRepeatCount }
    var isCompleted: Bool { currentCount >= targetCount }
    var progress: Double {
        targetCount > 0 ? min(Double(currentCount) / Double(targetCount), 1.0) : 1.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1. الترويسة: رقم الذكر بالورد وعنوانه وزر النسخ السريع
            HStack(alignment: .center) {
                // شارة الترقيم
                Text(String(format: "%02d", index + 1))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        isCompleted ? Color.emeraldSuccess : Color.crimsonPrimary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.antiqueGold.opacity(0.8), lineWidth: 1)
                    )

                Text(showTashkeel ? dhikr.title : dhikr.titleWithoutTashkeel)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.darkEspressoText)

                Spacer()

                // زر النسخ المباشر
                Button(action: {
                    UIPasteboard.general.string = showTashkeel ? dhikr.textWithTashkeel : dhikr.textWithoutTashkeel
                    onCopy()
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.antiqueGold)
                        .padding(8)
                        .background(Color.royalBeigeCardLight)
                        .clipShape(CircleShape())
                }
            }

            // 2. محراب نص الذكر الشريف
            Text(showTashkeel ? dhikr.textWithTashkeel : dhikr.textWithoutTashkeel)
                .font(.system(size: fontSizeSp, weight: .medium))
                .foregroundColor(.darkEspressoText)
                .lineSpacing(fontSizeSp * 0.55)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)

            // 3. صندوق الفضل النبوي والتوجيه
            if let virtue = dhikr.virtue, !virtue.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 14))
                        .foregroundColor(.antiqueGold)

                    Text(showTashkeel ? virtue : DhikrItem.removeArabicDiacritics(virtue))
                        .font(.system(size: 12.5, weight: .regular))
                        .foregroundColor(.darkEspressoText.opacity(0.9))
                        .lineSpacing(4)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.antiqueGold.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.antiqueGold.opacity(0.35), lineWidth: 0.8)
                )
            }

            Spacer().frame(height: 6)

            // 4. التنسيق السفلي المدمج:
            // [زر التسبيح] (على اليمين) | [شريط التقدم الطويل] (بالمنتصف) | [تصفير فوق، عداد تحت] (أقصى اليسار)
            HStack(spacing: 12) {
                // زر التسبيح (على اليمين)
                Button(action: {
                    if currentCount < targetCount {
                        currentCount += 1
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }) {
                    HStack(spacing: 6) {
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                            Text("اكتمل")
                                .font(.system(size: 13, weight: .bold))
                        } else {
                            if targetCount > 1 {
                                Text("تَسْبِيح (\(currentCount)/\(targetCount))")
                                    .font(.system(size: 12.5, weight: .bold))
                            } else {
                                Text("تَمَّتِ القِرَاءَةُ")
                                    .font(.system(size: 12.5, weight: .bold))
                            }
                        }
                    }
                    .frame(width: 92, height: 46)
                    .background(isCompleted ? Color.emeraldSuccess : Color.crimsonPrimary)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isCompleted ? Color.emeraldSuccess : Color.antiqueGold, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(isCompleted ? 0.0 : 0.15), radius: 3, y: 2)
                }
                .disabled(isCompleted)

                // العمود الأيسر (شريط التقدم وبجواره في أقصى اليسار: تصفير فوق، عداد تحت)
                VStack(spacing: 3) {
                    // السطر العلوي: زر التصفير
                    HStack {
                        Spacer()
                        if currentCount > 0 {
                            Button(action: onReset) {
                                HStack(spacing: 3) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 10))
                                    Text("تصفير")
                                        .font(.system(size: 11, weight: .semibold))
                                }
                                .foregroundColor(.antiqueGold)
                            }
                        } else {
                            Spacer().frame(height: 14)
                        }
                    }

                    // المنتصف: شريط التقدم الطويل جدًا
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.sandBorder.opacity(0.35))
                                .frame(height: 5.5)

                            RoundedRectangle(cornerRadius: 3)
                                .fill(isCompleted ? Color.emeraldSuccess : Color.crimsonPrimary)
                                .frame(width: geo.size.width * CGFloat(progress), height: 5.5)
                                .animation(.easeInOut(duration: 0.25), value: progress)
                        }
                    }
                    .frame(height: 5.5)

                    // السطر السفلي: عداد التسبيح
                    HStack {
                        Spacer()
                        Text(isCompleted ? "تم إتمام الذكر بنجاح ✓" : "\(currentCount) من أصل \(targetCount)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(isCompleted ? .emeraldSuccess : .mutedEspressoText)
                    }
                }
                .frame(height: 46)
            }
        }
        .padding(16)
        .background(isCompleted ? Color.royalBeigeCardLight : Color.royalBeigeCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isCompleted ? Color.emeraldSuccess.opacity(0.6) : Color.sandBorder, lineWidth: 1.2)
        )
        .shadow(color: Color.black.opacity(isCompleted ? 0.03 : 0.08), radius: 6, y: 3)
    }
}

// Support shape
struct CircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        return path
    }
}
