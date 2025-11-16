//
//  StoolRecordList.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/24.
//

import SwiftUI
import RealmSwift

struct StoolRecordList: View {
    
    @ObservedResults(StoolRecord.self) var stoolRecords
    @ObservedResults(DayRecord.self) var dayRecord
    
    @Binding var selectDay: Date
    
    var showView: () -> Void
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        let day = dayRecord.first { Calendar.current.isDate($0.date, inSameDayAs: selectDay) }
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            VStack {
                VStack {
                    CustomHStackView {
                        Text("today")
                    } intView: {
                        Text("\(day?.stoolRecord.count ?? 0)")
                    }
                    VStack {
                        HStack {
                            CustomHStackView {
                                Text("普通")
                            } intView: {
                                Text("\(day?.stoolRecord.filter { $0.type.contains(.normal) }.count ?? 0)")
                            }
                            CustomHStackView {
                                Text("硬便")
                            } intView: {
                                Text("\(day?.stoolRecord.filter { $0.type.contains(.hard) }.count ?? 0)")
                            }
                            CustomHStackView {
                                Text("軟便")
                            } intView: {
                                Text("\(day?.stoolRecord.filter { $0.type.contains(.soft) }.count ?? 0)")
                            }
                        }
                        HStack {
                            CustomHStackView {
                                Text("下痢")
                            } intView: {
                                Text("\(day?.stoolRecord.filter { $0.type.contains(.diarrhea) }.count ?? 0)")
                            }
                            CustomHStackView {
                                Text("便秘")
                            } intView: {
                                Text("\(day?.stoolRecord.filter { $0.type.contains(.constipation) }.count ?? 0)")
                            }
                            CustomHStackView {
                                Text("血便")
                            } intView: {
                                Text("\(day?.stoolRecord.filter { $0.type.contains(.blood) }.count ?? 0)")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                if let day = day {
                    if !day.stoolRecord.isEmpty {
                        ScrollView {
                            ForEach(day.stoolRecord, id: \.self) { stool in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                    
                                    HStack(spacing: 16) {
                                        // 回数（左側・強調）
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("\(stool.amount)")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.blue)
                                            //                                            Text("時刻")
                                            //                                                .font(.caption)
                                            //                                                .foregroundColor(.secondary)
                                            Text(dateFormatter.string(from: stool.time))
                                                .font(.system(size: 10))
                                                .foregroundColor(.primary)
                                            //                                            Text("回目")
                                            //                                                .font(.caption2)
                                            //                                                .foregroundColor(.secondary)
                                        }
                                        .frame(width: 30)
                                        
                                        Divider()
                                            .frame(height: 40)
                                        
                                        // 種類（中央）
                                        //                                        VStack(alignment: .leading, spacing: 4) {
                                        //                                            Text("種類")
                                        //                                                .font(.caption)
                                        //                                                .foregroundColor(.secondary)
                                        if stool.type.isEmpty {
                                            Text("-")
                                                .font(.body)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text(stool.type.map { $0.japaneseText }.joined(separator: " · "))
                                                .font(.system(size: 15))
                                            //                                                    .fontWeight(.medium)
                                                .foregroundColor(.primary)
                                        }
                                        //                                        }
                                        
                                                                                Spacer()
                                        
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .frame(height: 50)
                                .padding(.horizontal)
//                                .padding(.top)
//                                .padding(.vertical)
                                .padding(.vertical, 10)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteSingleStoolRecord(stool, in: day)
                                    } label: {
                                        Label("削除", systemImage: "trash")
                                    }
                                }
                            }
//                            .onDelete { indexSet in
//                                deleteStoolRecords(at: indexSet, in: day)
//                            }
                        }
                        .padding(.top)
//                        .padding()
                    } else {
                        Text("記録はありません")
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                            .padding()
//                        Spacer()

                    }
                } else {
                    Text("記録はありません")
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                        .padding()
//                    Spacer()
                }
                Spacer()
                Button(action: {
                    showView()
                }) {
                    Text("閉じる")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.gray)
                        )
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    private func deleteSingleStoolRecord(_ stool: StoolRecord, in day: DayRecord) {
        let realm = try! Realm()
        
        guard let thawedDay = day.thaw(),
              let index = thawedDay.stoolRecord.firstIndex(of: stool) else { return }
        
        try! realm.write {
            // 対象削除
            let itemToDelete = thawedDay.stoolRecord[index]
            realm.delete(itemToDelete)
            
            // amountをリセット
            for (i, stool) in thawedDay.stoolRecord.enumerated() {
                stool.amount = i + 1
            }
        }
    }
}

#Preview {
    StoolRecordList(selectDay: .constant(Date()), showView: {})
}
