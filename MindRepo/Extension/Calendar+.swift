//
//  Calendar+.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//

import Foundation

extension Calendar {
    /// 해당 날짜가 속한 달의 1일을 반환
    func startOfMonth(for date: Date) -> Date {
        let comps = dateComponents([.year, .month], from: date)
        return self.date(from: comps) ?? date
    }
    
    /// 해당 날짜가 속한 달의 일 수 반환
    func numberOfDays(inMonthContaining date: Date) -> Int {
        guard let range = range(of: .day, in: .month, for: date) else { return 0 }
        return range.count
    }
    
    /// 1일이 무슨 요일(1=Sunday … 7=Saturday)인지 반환
    func weekdayOfFirstDay(inMonth date: Date) -> Int {
        let first = startOfMonth(for: date)
        return component(.weekday, from: first)
    }
    
    /// 해당 날짜가 표시되는 달에 속하는지 여부 반환
    func isDateInDisplayedMonth(_ date: Date, anchorMonth: Date) -> Bool {
        let lhs = dateComponents([.year, .month], from: date)
        let rhs = dateComponents([.year, .month], from: anchorMonth)
        return lhs.year == rhs.year && lhs.month == rhs.month
    }
}
