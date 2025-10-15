//
//  CalendarViewModel.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//

import SwiftUI
import SwiftData

@Observable
final class CalendarViewModel {
    private let calendar: Calendar
    private let context: ModelContext
    /// 헤더에 표시되는 달(1일 기준)
    var displayedMonth: Date
    /// 선택 날짜
    var selectedDate: Date?
    /// 현재 달(그리드에 필요한 전달/다음달의 경계 날짜 포함)을 표현하는 단일 모델
    private(set) var month: MonthGrid
    
    init(
        context: ModelContext,
        displayedMonth: Date = .now,
        selectedDate: Date? = .now,
        calendar: Calendar = .current
    ) {
        self.calendar = calendar
        /// month anchor를 항상 그 달의 1일로 정규화
        let comps = calendar.dateComponents([.year, .month], from: displayedMonth)
        let displayedMonth = calendar.date(from: comps) ?? displayedMonth
        self.displayedMonth = displayedMonth
        self.selectedDate = selectedDate
        self.month = MonthGrid(anchorMonth: displayedMonth, cells: [])
        self.context = context
    }
    
    /// 이전 달로 변경
    func goToPreviousMonth() {
        if let prev = calendar.date(byAdding: .month, value: -1, to: displayedMonth) {
            displayedMonth = calendar.startOfMonth(for: prev)
        }
    }
    
    /// 다음 달로 변경
    func goToNextMonth() {
        if let next = calendar.date(byAdding: .month, value: 1, to: displayedMonth) {
            displayedMonth = calendar.startOfMonth(for: next)
        }
    }
    
    /// 날짜 선택
    func select(_ date: Date) {
        selectedDate = date
    }
    
    /// 선택된 날짜에 해당하는 일기 반환
    var selectedDiary: Diary? {
        guard let selectedDate else { return nil }
        let key = calendar.startOfDay(for: selectedDate)
        return month.cells.first { calendar.isDate($0.date, inSameDayAs: key) }?.diary
    }
    
    /// 현재 달이 변경될 때마다 month 모델 갱신
    func onDisplayedMonthUpdated() throws {
        let newMonth = try buildMonthGrid(for: displayedMonth)
        self.month = newMonth
    }
    
    /// 해당 날짜가 선택된 상태인지 여부
    func isSelected(_ date: Date) -> Bool {
        guard let selectedDate else { return false }
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }
}

extension CalendarViewModel {
    /// 현재 달을 기준으로 MonthGrid 모델 생성
    private func buildMonthGrid(for anchor: Date) throws -> MonthGrid {
        var cells: [DayCellInfo] = []
        
        let anchorStart = calendar.startOfMonth(for: anchor)
        let prevStart = calendar.startOfMonth(for: calendar.date(byAdding: .month, value: -1, to: anchorStart)!)
        let nextStart = calendar.startOfMonth(for: calendar.date(byAdding: .month, value: 1, to: anchorStart)!)
        
        /// 이번달 일기 불러오기
        let diaryBucket = try fetchDiary(in: anchorStart..<nextStart)
        
        /// 지난달 말, 다음달 초 계산
        let firstWeekday = calendar.weekdayOfFirstDay(inMonth: anchorStart)
        let leading = (firstWeekday - calendar.firstWeekday + 7) % 7
        let daysInAnchor = calendar.numberOfDays(inMonthContaining: anchorStart)
        
        //// 지난달 말 추가
        if leading > 0 {
            let prevDaysInMonth = calendar.numberOfDays(inMonthContaining: prevStart)
            let startDay = prevDaysInMonth - leading + 1
            for day in startDay...prevDaysInMonth {
                let date = calendar.date(bySetting: .day, value: day, of: prevStart) ?? prevStart
                cells.append(DayCellInfo(
                    date: date,
                    part: .previous,
                    isToday: calendar.isDateInToday(date),
                    diary: nil
                ))
            }
        }
        /// 이번달 추가
        for day in 1...daysInAnchor {
            let date = calendar.date(bySetting: .day, value: day, of: anchorStart) ?? anchorStart
            let key = calendar.startOfDay(for: date)
            cells.append(DayCellInfo(
                date: date,
                part: .current,
                isToday: calendar.isDateInToday(date),
                diary: diaryBucket[key]
            ))
        }
        /// 다음달 초 추가
        let remainder = (leading + daysInAnchor) % 7
        let trailing = remainder == 0 ? 0 : 7 - remainder
        if trailing > 0 {
            for day in 1...trailing {
                let date = calendar.date(bySetting: .day, value: day, of: nextStart) ?? nextStart
                cells.append(DayCellInfo(
                    date: date,
                    part: .next,
                    isToday: calendar.isDateInToday(date),
                    diary: nil
                ))
            }
        }
        
        return MonthGrid(anchorMonth: anchorStart, cells: cells)
    }
    
    /// 해당 기간 내의 일기들을 불러와 날짜별로 매핑
    private func fetchDiary(in range: Range<Date>) throws -> [Date: Diary] {
        let start = range.lowerBound
        let end = range.upperBound
        
        var descriptor = FetchDescriptor<Diary>()
        descriptor.predicate = #Predicate<Diary> { d in
            d.date >= start && d.date < end
        }
        descriptor.sortBy = [SortDescriptor(\.date, order: .forward)]
        
        let diaries = try context.fetch(descriptor)
        
        var bucket: [Date: Diary] = [:]
        for d in diaries {
            let dayKey = calendar.startOfDay(for: d.date)
            // TODO: - Diary 날짜 제한 걸기
            bucket[dayKey] = d
        }
        return bucket
    }
}
