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
        VStack(alignment: .leading) {
            MonthlyCalendarView(vm: vm)
            
            if let diary = vm.selectedDiary {
                DiaryView(diary: diary)
            } else {
                emptyView
            }
            
            Spacer()
        }
    }
    
    private var emptyView: some View {
        // TODO: - DiaryView와 공통 스타일링 고려
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(minHeight: 100)
                .foregroundStyle(.gray.opacity(0.1))
            
            VStack {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .padding(.bottom, 5)
                Text("기록 없음")
                    .foregroundStyle(.gray)
                
                Button {
                    // TODO: - 날짜 바탕 추가
                } label: {
                    Text("기록 추가")
                        .bold()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue.opacity(0.2))
                        }
                }
            }
        }
        .padding()
    }
}

#Preview(traits: .diarySample) {
    @Previewable @Environment(\.modelContext) var context
    CalendarView(modelContext: context)
}
