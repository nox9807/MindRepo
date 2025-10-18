//
//  DiaryListView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//
import SwiftUI
import SwiftData


// TODO: - HeaderView 적용 // Ok
// TODO: - toolbar로 추가, 검색 버튼 위치
struct DiaryListView: View {
    
    @Query(sort: \Diary.date, order: .reverse) private var items: [Diary]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State var year = Calendar.current.component(.year, from: .now)
    @State var month = Calendar.current.component(.month, from: .now)
    @State var selection = Date()
    
    @State var showSearch: Bool = false // 추후 수정
    @State var showPicker: Bool = false
    @State var keyword: String = ""
    
    let action: () -> Void
    
    var filterdItmes: [Diary] {
        if keyword.isEmpty {
            return items
        } else {
            return items.filter {
            return $0.content.lowercased().contains(keyword.lowercased())
        }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: 날짜 + 버튼
                HStack() {
                    CommonLayoutView {
                        Text("일기목록")
                            .font(.largeTitle)
                        
                        // 날짜 Picker
                        Button {
                            showPicker = true
                        } label: {
                            HStack {
                                Text("\(year.formatted(.number.grouping(.never)))년 \(month)월")
                                    .foregroundStyle(Color.textPrimary)
                                
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.appPrimary)
                            }
                            .bold()
                        }
                    } content: {
                        
                    }
                    
                    Spacer()
                    
                    // 작성 버튼
                    Button {
                        action()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.appPrimary)
                            .bold()
                    }
                    
                    // 돋보기 버튼
                    Button {
                        showSearch = true // 추후 수정
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.appPrimary)
                            .bold()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                // MARK: ScrollView로 목록 구현
                ScrollView(showsIndicators: false){
                    ForEach(filterdItmes) { item in
                        // TODO: - 수정, 삭제 기능
                        DiaryView(diary: item)
                            .contextMenu {
                                Button(role: .destructive){
                                    context.delete(item)
                                } label: {
                                   Label("삭제", systemImage: "trash")
                                }

                            }
                            .onTapGesture {
                                /// 수정 기능
                            }
                    }
                }
            }
            // 백그라운 컬러
            .background(Color.appBackground.opacity(0.95))
        }
        .sheet(isPresented: $showPicker) {
            CustomDatePicker(year: $year, month: $month) {
                showPicker = false
            }
        }
        .presentationDetents([.height(300)])
    }
}

#Preview(traits: .diarySample) {
    DiaryListView(action: {})
}
