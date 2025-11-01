//
//  StoolRecordCharts.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/29.
//

import SwiftUI
import SwiftUICharts
import RealmSwift
import Charts

//struct StoolRecordCharts: View {
//    
//    @ObservedResults(StoolRecord.self) var stoolRecords
//    @ObservedResults(DayRecord.self) var dayRecord
//    
//    @Binding var selectDay: Date
//    
//    var body: some View {
//        let selectedMonth = Calendar.current.component(.month, from: selectDay)
//        let selectedYear = Calendar.current.component(.year, from: selectDay)
//        
//        // 同じ「年・月」に該当するDayRecordを抽出
//        let monthRecords = dayRecord.filter {
//            let components = Calendar.current.dateComponents([.year, .month], from: $0.date)
//            return components.year == selectedYear && components.month == selectedMonth
//        }
//        
//        // 各日付ごとに含まれる StoolRecord をフラット化（全データまとめ）
//        let allStoolRecords = monthRecords.flatMap { $0.stoolRecord }
//        
//        // 時間順に並べ替え
//        let sortedRecords = allStoolRecords.sorted(by: { $0.time < $1.time })
//        
//        // グラフ用データ変換（x軸＝日付 or 時間、y軸＝量）
//        let chartData = sortedRecords.map {
//            let dayString = DateFormatter.localizedString(from: $0.time, dateStyle: .short, timeStyle: .none)
//            return (dayString, Double($0.amount))
//        }
//        
//        VStack {
//            if !chartData.isEmpty {
//                BarChartView(
//                    data: ChartData(values: chartData),
//                    title: "\(selectedMonth)月の排便量",
//                    legend: "日別",
//                    style: ChartStyle(
//                        backgroundColor: .white,
//                        accentColor: .green,
//                        secondGradientColor: .green.opacity(0.5),
//                        textColor: .black,
//                        legendTextColor: .gray,
//                        dropShadowColor: .gray
//                    ), form: ChartForm.medium
//                )
//                .frame(height: 250)
//            } else {
//                Text("この月のデータはありません")
//                    .foregroundColor(.gray)
//                    .padding()
//            }
//        }
//    }
//}
struct StoolRecordCharts: View {
    @ObservedResults(DayRecord.self) var dayRecords
    @Binding var selectedDay: Date
    
    var body: some View {
        // 選択月と年を取得
        let selectedMonth = Calendar.current.component(.month, from: selectedDay)
        let selectedYear = Calendar.current.component(.year, from: selectedDay)
        
        // 同じ年・月のDayRecordを取得
        let monthRecords = dayRecords.filter {
            let comps = Calendar.current.dateComponents([.year, .month], from: $0.date)
            return comps.year == selectedYear && comps.month == selectedMonth
        }
        
        // すべてのStoolRecordをまとめる
        let allStoolRecords = Array(monthRecords.flatMap { $0.stoolRecord })

        // データがある場合のみグラフを表示
        VStack(alignment: .leading) {
            Text("\(selectedMonth)月の排便回数")
                .font(.headline)
                .padding(.horizontal)
            
            if allStoolRecords.isEmpty {
                Text("この月のデータはありません")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart {
                    ForEach(allStoolRecords) { record in
                        LineMark(
                            x: .value("日付", dayString(from: record.time)),
                            y: .value("回数", record.amount)
                        )
                        .foregroundStyle(.green.gradient)
                    }
                }
                .chartYAxisLabel("回数")
                .frame(height: 250)
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Helper
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d日"
        return formatter.string(from: date)
    }
}


#Preview {
    StoolRecordCharts(selectedDay: .constant(Date()))
}
