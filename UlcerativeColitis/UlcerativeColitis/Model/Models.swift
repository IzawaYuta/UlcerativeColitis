//
//  Models.swift
//  UlcerativeColitis
//
//  Created by Engineer MacBook Air on 2025/10/23.
//

import Foundation
import RealmSwift

enum StoolType: String, PersistableEnum {
    case normal //普通便
    case soft //軟便
    case diarrhea //下痢
    case blood //血便
}

enum Timing: String, PersistableEnum {
    case morning //朝
    case noon //昼
    case evening //夕
    case wakeUp //起床時
    case bedtime //就寝前
    case justBeforeMeals //食直前
    case beforeMeals //食前
    case immediatelyAfterMeals //食直後
    case afterMeals //食後
    case temporaryClothes //頓服
    
    var japaneseText: String {
        switch self {
        case .morning: 
            return "朝"
        case .noon: return 
            "昼"
        case .evening: 
            return "夕"
        case .wakeUp: 
            return "起床時"
        case .bedtime: 
            return "就寝前"
        case .justBeforeMeals: 
            return "食直前"
        case .beforeMeals: 
            return "食前"
        case .immediatelyAfterMeals: 
            return "食直後"
        case .afterMeals: 
            return "食後"
        case .temporaryClothes: 
            return "頓服"
        }
    }
}

class DayRecord: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var stoolRecord = List<StoolRecord>()
    @Persisted var schedule = List<Schedule>()
}

class StoolRecord: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var time: Date //時間
    @Persisted var amount: Int //回数
    @Persisted var type = List<StoolType>() //種類
}

class MedicineInfo: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var medicineName: String //お薬の名前
    @Persisted var unit: String //単位
    @Persisted var dosage: Int //用量
    @Persisted var timing = List<Timing>() //服用タイミング
    @Persisted var time: Date //服用時間
    @Persisted var effect: String //効果
    @Persisted var stock: Int //在庫
    @Persisted var isUsing: Bool = true //使用or不使用
}

class Schedule: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String
    @Persisted var allDate: Bool = false
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var memo: String?
}
