//
//  Date+.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//

import Foundation

extension Date {
    
    // MARK: - Shared formatter: `2025년 10월 14일` 형태
    
    fileprivate static let koYMDFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "yyyy년 MM월 dd일"
        return df
    }()

    /// `selectedDate.formattedYMD_ko`를 이용하는 포맷
    var formattedYMD_ko: String {
        Self.koYMDFormatter.string(from: self)
    }
    
    // MARK: - Shared formatter: `10월 2025` 형태
    
    fileprivate static let koMYFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "MM월 yyyy"
        return df
    }()
    
    /// `selectedDate.formattedMY_ko`를 이용하는 포맷
    var formattedMY_ko: String {
        Self.koMYFormatter.string(from: self)
    }
}
