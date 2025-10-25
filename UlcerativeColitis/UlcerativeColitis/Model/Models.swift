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

class DayRecord: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var stoolRecord = List<StoolRecord>()
}

class StoolRecord: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var time: Date //時間
    @Persisted var amount: Int //回数
    @Persisted var type = List<StoolType>() //種類
}
