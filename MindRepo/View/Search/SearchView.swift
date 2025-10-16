//
//  SearchView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/16/25
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Query private var diaries: [Diary]
    @State private var searchText: String = ""
    @State private var selectedMoods: Set<Mood> = []
    
    var dismiss: () -> Void = {}
    
    /// 검색어 + 기분 필터를 모두 적용한 결과
    private var results: [Diary] {
        let contentFiltered: [Diary]
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentFiltered = diaries
        } else {
            contentFiltered = diaries.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
        }
        guard !selectedMoods.isEmpty else { return contentFiltered }
        return contentFiltered.filter { selectedMoods.contains($0.mood) }
    }
    
    /// 기분 필터 토글
    private func toggleMood(_ mood: Mood) {
        if selectedMoods.contains(mood) {
            selectedMoods.remove(mood)
        } else {
            selectedMoods.insert(mood)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        moodFilterButton(mood)
                    }
                }
                .padding(.horizontal)
                
                List {
                    ForEach(results) { diary in
                        
                        // MARK: - DiaryContentView
                        
                        VStack(alignment: .leading) {
                            Text(diary.content)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(Color.clear)
                    .padding(.horizontal)
                }
                .listStyle(.plain)
            }
            .searchable(text: $searchText, prompt: "내용을 입력하세요")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
            }
        }
    }
    
    // MARK: - Mood 필터 버튼
    
    private func moodFilterButton(_ mood: Mood) -> some View {
        let isOn = selectedMoods.contains(mood)
        
        return Button {
            toggleMood(mood)
        } label: {
            Text(mood.title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isOn ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
        
    }
    
}

#Preview(traits: .diarySample) {
    SearchView()
}
