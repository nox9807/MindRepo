//
//  DiaryEditorView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//

import SwiftUI
import SwiftData

struct DiaryEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    /// 편집할 일기 (nil이면 새 일기 작성)
    let diary: Diary?
    /// 작성/수정할 내용
    @State private var content: String
    @State private var selectedMood: Mood
    @State private var selectedDate: Date = .now
    /// 날짜 선택 시트 표시 여부
    @State private var isDateSheetPresented = false
    /// 기분 선택 그리드 컬럼
    private let moodColumns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)
    /// 편집 모드 여부
    private var isEditing: Bool { diary != nil }
    private var isUnchanged: Bool {
        guard let diary else { return false }
        return diary.content == content &&
               diary.mood == selectedMood &&
               Calendar.current.isDate(diary.date, inSameDayAs: selectedDate)
    }
    /// 저장 버튼 비활성화 여부
    private var isSaveDisabled: Bool {
        if isEditing {
            return isUnchanged
        } else {
            return content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    init(diary: Diary? = nil) {
        self.diary = diary
        _content = State(initialValue: diary?.content ?? "")
        _selectedMood = State(initialValue: diary?.mood ?? .neutral)
        _selectedDate = State(initialValue: diary?.date ?? .now)
    }
    
    /// 일기 저장
    private func save() {
        if let diary {
            diary.content = content
            diary.mood = selectedMood
            diary.date = selectedDate
            diary.updatedAt = .now
        } else {
            let newDiary = Diary(content: content, mood: selectedMood, date: selectedDate)
            modelContext.insert(newDiary)
        }
        try? modelContext.save()
    }
    
    /// 일기 삭제
    private func delete() {
        if let diary {
            modelContext.delete(diary)
            try? modelContext.save()
        }
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // MARK: - 날짜 선택 버튼
                
                Button {
                    isDateSheetPresented = true
                } label: {
                    dateTextView(selectedDate)
                }
                .buttonStyle(.plain)
                .padding(5)
                
                // MARK: - 감정 선택 그리드
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("기분 선택")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("오늘의 기분을 선택해 주세요.")
                            .foregroundStyle(.secondary)
                    }
                    
                    LazyVGrid(columns: moodColumns, spacing: 12) {
                        ForEach(Mood.allCases, id: \.self) { mood in
                            Button {
                                selectedMood = mood
                            } label: {
                                emojiTextView(mood, isSelected: selectedMood == mood)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .modifier(SectionCard())
                
                // MARK: - 내용 입력 뷰
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("일기 입력")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    customTextEditor($content)
                }
                .modifier(SectionCard())
                
                // MARK: - 삭제 버튼
                
                if isEditing {
                    Button(role: .destructive) {
                        delete()
                    } label: {
                        Image(systemName: "trash")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.red.opacity(0.1))
                    )
                }
            }
            .padding()
            .navigationTitle(isEditing ? "일기 수정" : "일기 작성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        save()
                        dismiss()
                    }
                    .disabled(isSaveDisabled)
                }
            }
        }
        .sheet(isPresented: $isDateSheetPresented) {
            sheetContent
                .padding()
                .presentationDetents([.height(420), .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    /// 플레이스홀더 텍스트 에디터
    private func customTextEditor(_ content: Binding<String>) -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $content)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(maxHeight: .infinity)
                .padding(.leading, -5)
            
            if content.wrappedValue.isEmpty {
                Text("오늘의 마음을 기록해보세요.")
                    .foregroundStyle(.gray.opacity(0.6))
                    .padding(.top, 8)
                    .allowsHitTesting(false)
            }
        }
    }
    
    /// 날짜 포맷 텍스트 뷰
    private func dateTextView(_ date: Date) -> some View {
        HStack(spacing: 6) {
            Text(date.formattedYMD_ko)
                .font(.headline)
            Image(systemName: "chevron.down")
                .font(.caption)
        }
    }
    
    /// 이모지와 텍스트 뷰
    private func emojiTextView(_ mood: Mood, isSelected: Bool) -> some View {
        VStack(spacing: 3) {
            Text(mood.emoji)
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .opacity(isSelected ? 1.0 : 0.5)
            Text(mood.title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .bold(isSelected)
        }
    }
    
    // MARK: - 날짜 선택 시트 내용
    
    private var sheetContent: some View {
        VStack(spacing: 12) {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()

            Button("완료") {
                isDateSheetPresented = false
            }
            .font(.headline)
        }
    }
}

// MARK: - Section Card 스타일 적용 수정자

fileprivate struct SectionCard: ViewModifier {
    var cornerRadius: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.secondary.opacity(0.15))
            )
    }
}

#Preview("New Diary", traits: .diarySample) {
    DiaryEditorView()
}

#Preview("Edit Diary", traits: .diarySample) {
    DiaryEditorView(diary: Diary.dummy.first!)
}
