//
//  TabItem.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/17/25
//


import SwiftUI

enum TabItem: CaseIterable {
    case list
    case calendar
    case stats

    var title: String {
        switch self {
        case .list: return "목록"
        case .calendar: return "달력"
        case .stats: return "통계"
        }
    }

    var systemImage: String {
        switch self {
        case .list: return "document"
        case .calendar: return "calendar"
        case .stats: return "chart.pie"
        }
    }

    func color(_ isSelected: Bool) -> Color {
        isSelected ? .primary : .secondary
    }
}
