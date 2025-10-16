//
//  MonthlyCalendarView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//

import SwiftUI
import SwiftData

// MARK: - MonthlyCalendar

struct MonthlyCalendarView: View {
    @Bindable var vm: CalendarViewModel
    /// 스타일 관련 속성
    var columnSpacing: CGFloat = 4
    var rowSpacing: CGFloat = 8
    var gaps: CGFloat = 6 /// 7 cols -> 6 gaps
    /// 요일과 column 그리드 배열
    private let symbols = ["일", "월", "화", "수", "목", "금", "토"]
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: columnSpacing, alignment: .center), count: 7)
    }
    
    var body: some View {
        VStack {
            header
            weekdayHeader
            monthGrid
        }
        .padding()
        .task(id: vm.displayedMonth) {
            try? vm.onDisplayedMonthUpdated()
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Text(vm.displayedMonth.formattedMY_ko)
                .font(.headline)
            Spacer()
            HStack(spacing: 25) {
                Button {
                    vm.goToPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button {
                    vm.goToNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.primary)
            .bold()
        }
        .padding()
    }
    
    // MARK: - Weekday header
    
    private var weekdayHeader: some View {
        LazyVGrid(columns: columns, spacing: rowSpacing) {
            ForEach(0..<7, id: \.self) { index in
                let label = symbols[index]
                Text(label.uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
            }
            .foregroundStyle(.secondary)
        }
    }
    
    // MARK: Month grid
    
    private var monthGrid: some View {
        LazyVGrid(columns: columns, spacing: rowSpacing) {
            ForEach(vm.month.cells, id: \.date) { info in
                DayCell(info: info, checkSelected: vm.isSelected)
                    .overlay(alignment: .bottom) {
                        if let diary = info.diary {
                            diaryMarker(diary.mood.color)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        if info.part == .current {
                            vm.select(info.date)
                        }
                    }
            }
        }
    }
    
    private func diaryMarker(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 6, height: 6)
            .offset(y: -3)
    }
}

// MARK: - Day cell

fileprivate struct DayCell: View {
    let info: DayCellInfo
    let checkSelected: (Date) -> Bool
    /// 선택된 날짜인지 여부
    var isSelected: Bool { checkSelected(info.date) }
    var isSelectedToday: Bool { isSelected && info.isToday }
    /// 배경 색상 결정
    var bgFill: Color {
        if isSelectedToday { return .accentColor }
        if isSelected { return Color.accentColor.opacity(0.15) }
        return .clear
    }
    /// 텍스트 색상 결정 (이번달이 아니면 흐리게)
    var textColor: Color {
        if isSelectedToday { return .white }
        if isSelected { return .accentColor }
        if info.isToday { return .accentColor }
        return info.part == .current ? .primary : .clear
    }
    
    var body: some View {
        ZStack {
            /// 배경 원
            Circle()
                .fill(bgFill)
                .frame(width: 40, height: 40)
            /// 날짜 숫자
            Text("\(Calendar.current.component(.day, from: info.date))")
                .font(.body)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(textColor)
        }
        .contentShape(.rect)
    }
}

// MARK: - Preview

#Preview(traits: .diarySample) {
    @Previewable @Environment(\.modelContext) var context
    
    MonthlyCalendarView(vm: .init(context: context))
}
