//
//  DiaryListView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//
import SwiftUI
import SwiftData

struct CustomYearMonthPickerView: View {
    @Binding var year: Int
    @Binding var month: Int
    var onDone: () -> Void = {}
    
    let years = Array(2022...2035)
    let months = Array(1...12)
    
    var body: some View {
        VStack {
            Text("선택하실 년도와 월을 고르세요.")
                .font(.headline)
            
            HStack {
                Picker("Year", selection: $year) {
                    ForEach(years, id: \.self) {
                        Text("\($0.formatted(.number.grouping(.never)))년").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Month", selection: $month) {
                    ForEach(months, id: \.self) {
                        Text("\($0)월").tag($0)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 170)
            
            Button("완료", action: onDone)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

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
    
    var filterdItmes: [Diary] {
        if keyword.isEmpty {return items}
        else { return items.filter {
            return $0.content.lowercased().contains(keyword.lowercased())
        }}
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: Title + 검색버튼
                HStack() {
                    Text("일기목록")
                        .font(.title3)
                        .bold()
                    
                    Spacer()
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
                
                // MARK: 캘린더 구현
                HStack {
                    
                    Spacer()
                    
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
                        CustomYearMonthPickerView(year: $year, month: $month) {
                            showPicker = false
                        }
                    }
                    .presentationDetents([.height(300)])
                }
                .padding(.horizontal)
                
                // MARK: ScrollView로 목록 구현
                ScrollView(showsIndicators: false){
                    ForEach(filterdItmes) { item in
                        DiaryView(diary: item)
                            .border(Color.black)
                    }
                }
                .border(Color.black)
            }
            .background(.cyan.opacity(0.01))
        }
        
    }
}

#Preview(traits: .diarySample) {
    DiaryListView()
}
