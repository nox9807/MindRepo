//
//  CalendarView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var vm: CalendarViewModel
    
    init(modelContext: ModelContext) {
        _vm = State(wrappedValue: CalendarViewModel(context: modelContext))
    }
    
    var body: some View {
        VStack {
            MonthlyCalendarView(vm: vm)
            
            if let diary = vm.selectedDiary {
                TempDiaryView(diary: diary)
            } else {
                Text("기록 없음")
            }
        }
        
    }
}

fileprivate struct TempDiaryView: View {
    let diary: Diary
    
    var body: some View {
        Text(diary.content)
    }
}

#Preview(traits: .diarySample) {
    @Previewable @Environment(\.modelContext) var context
    CalendarView(modelContext: context)
}
