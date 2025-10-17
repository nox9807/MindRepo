//
//  DiaryListView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//
import SwiftUI
import SwiftData



struct DiaryListView: View {
    
    //@Query private var items: [Diary]
    @Query(sort: \Diary.date, order: .reverse) private var items: [Diary]
    @Environment(\.dismiss) private var dismiss
    @State var year = Calendar.current.component(.year, from: .now)
    @State var month = Calendar.current.component(.month, from: .now)
    @State var selection = Date()
    
    @State var showSearch: Bool = false
    @State var showPicker: Bool = false
    @State var keyword: String = ""
    
    let action: () -> Void
    
    var filterdItmes: [Diary] {
        if keyword.isEmpty {return items}
        else { return items.filter {
            return $0.content.lowercased().contains(keyword.lowercased())
        }}
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: 날짜 + 버튼
                HStack() {
                    // 날짜 Picker
                    Button {
                        showPicker = true
                    } label: {
                        HStack {
                            Text("\(year.formatted(.number.grouping(.never)))년 \(month)월")
                                .padding(.horizontal, -5)
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(.gray)
                        .bold()
                    }
                    .sheet(isPresented: $showPicker) {
                        CustomDatePicker(year: $year, month: $month) {
                            showPicker = false
                        }
                    }
                    .presentationDetents([.height(300)])
                    .padding(.leading)
                    Spacer()
                    
                    // 작성 버튼
                    Button {
                        action()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.gray)
                            .bold()
                    }
                    
                    // 돋보기 버튼
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                            .bold()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: ScrollView로 목록 구현
                ScrollView(showsIndicators: false){
                    ForEach(filterdItmes) { item in
                        DiaryView(diary: item)
                    }
                }
            }
            .background(.cyan.opacity(0.01))
            .navigationTitle("일기목록")
        }
       
    }
}

#Preview(traits: .diarySample) {
    DiaryListView(action: {})
}
