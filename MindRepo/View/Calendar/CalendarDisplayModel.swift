//
//  CalendarDisplayModel.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//

import Foundation

// MARK: - CalendarViewModel에서 사용되는 모델

/// 현재 월의 달력 그리드 정보를 담고 있는 구조체
struct MonthGrid {
    let anchorMonth: Date
    let cells: [DayCellInfo]
}

/// 달력의 각 날짜 셀 정보를 담고 있는 구조체
struct DayCellInfo {
    let date: Date
    let part: MonthPart
    let isToday: Bool
    let diary: Diary?
}

enum MonthPart { case previous, current, next }
