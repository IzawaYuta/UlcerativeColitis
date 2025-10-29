//
//  MedicineInfoView.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/27.
//

import SwiftUI
import RealmSwift

struct MedicineInfoView: View {
    
    @ObservedResults(MedicineInfo.self) var medicineInfo
    
    @State private var medicineName: String = ""
    @State private var dosage: Int = 0
    @State private var selectedTimings: Set<Timing> = []

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("お薬の名前")
                TextField("", text: $medicineName)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            HStack {
                Text("1回")
                TextField("", value: $dosage, format: .number)
                if let firstUnit = medicineInfo.first?.unit {
                    Text(firstUnit)
                } else {
                    Text("-")
                }
            }
            
            VStack(alignment: .center) {
                HStack {
                    ForEach([Timing.morning, .noon, .evening], id: \.self) { timing in
                        CustomButton(
                            color: selectedTimings.contains(timing) ? getColor(for: timing) : .white,
                            selected: selectedTimings,
                            timing: timing,
                            action: {
                                toggle(timing)
                            }) {
                            Text(timing.japaneseText)
                        }
                        .frame(width: 60, height: 35)
                    }
                }
                .padding(.vertical, 5)
                
                HStack {
                    ForEach([Timing.wakeUp, .bedtime, .temporaryClothes], id: \.self) { timing in
                        CustomButton(action: {
                            
                        }) {
                            Text(timing.japaneseText)
                        }
                        .frame(width: 60, height: 35)
                    }
                }
                .padding(.vertical, 5)
                
                HStack {
                    ForEach([Timing.justBeforeMeals, .beforeMeals, .immediatelyAfterMeals, .afterMeals], id: \.self) { timing in
                        CustomButton(action: {
                            
                        }) {
                            Text(timing.japaneseText)
                        }
                        .frame(width: 60, height: 35)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    private func toggle(_ timing: Timing) {
        if selectedTimings.contains(timing) {
            selectedTimings.remove(timing)
        } else {
            selectedTimings.insert(timing)
        }
    }
    
    func getColor(for timing: Timing) -> Color {
        switch timing {
        case .morning:
            return .orange.opacity(0.8)
        case .noon:
            return .yellow.opacity(0.8)
        case .evening:
            return .purple.opacity(0.8)
        case .wakeUp:
            return .green.opacity(0.8)
        case .bedtime:
            return .blue.opacity(0.8)
        case .justBeforeMeals:
            return .brown.opacity(0.8)
        case .beforeMeals:
            return .red.opacity(0.8)
        case .immediatelyAfterMeals:
            return .cyan.opacity(0.8)
        case .afterMeals:
            return .indigo.opacity(0.8)
        case .temporaryClothes:
            return .gray.opacity(0.8)
        }
    }
}

#Preview {
    MedicineInfoView()
}
