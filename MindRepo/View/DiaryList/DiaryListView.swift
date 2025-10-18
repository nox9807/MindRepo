//
//  DiaryListView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//
import SwiftUI
import SwiftData


// TODO: - 데이터 없음 표시
struct DiaryListView: View {
    @Query(sort: \Diary.date, order: .reverse) private var items: [Diary]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(EditorSheetManager.self) private var manager
    
    @State var year = Calendar.current.component(.year, from: .now)
    @State var month = Calendar.current.component(.month, from: .now)
    @State var selection = Date()
    
    @State var showSearch: Bool = false
    @State var showPicker: Bool = false
    @State var keyword: String = ""
    
    var filterdItmes: [Diary] {
        if keyword.isEmpty {
            return items
        } else {
            return items.filter {
            return $0.content.lowercased().contains(keyword.lowercased())
        }
        }
    }
    
    func toggleSearch() {
        showSearch.toggle()
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if showSearch {
                    SearchView(dismiss: toggleSearch)
                } else {
                    content
                }
            }
            .background(Color.appBackground.opacity(0.95))
        }
    }
    
    // MARK: - 기존 리스트 뷰
    private var content: some View {
        CommonLayoutView {
            VStack {
                Text("일기목록")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
//                monthSelectionButton
//                    .padding(.leading)
            }
            .padding(5)
        } content: {
            diaryList
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.appPrimary)
                        .bold()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    manager.presentNewDiary()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.appPrimary)
                        .bold()
                }
            }
        }
//        .sheet(isPresented: $showPicker) {
//            CustomDatePicker(year: $year, month: $month) {
//                showPicker = false
//            }
//            .presentationDetents([.height(300)])
//        }
    }
    
//    private var monthSelectionButton: some View {
//        Button {
//            showPicker = true
//        } label: {
//            HStack {
//                Text("\(year.formatted(.number.grouping(.never)))년 \(month)월")
//                    .foregroundStyle(Color.textPrimary)
//                
//                Image(systemName: "chevron.down")
//                    .foregroundStyle(Color.appPrimary)
//            }
//            .bold()
//        }
//    }
    
    private var diaryList: some View {
        VStack {
            // MARK: ScrollView로 목록 구현
            ScrollView(showsIndicators: false){
                ForEach(filterdItmes) { item in
                    DiaryView(diary: item)
                        .contextMenu {
                            Button(role: .destructive) {
                                modelContext.delete(item)
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            manager.presentEditDiary(item)
                        }
                }
            }
        }
    }
}

#Preview(traits: .diarySample) {
    DiaryListView()
        .environment(EditorSheetManager.shared)
}
