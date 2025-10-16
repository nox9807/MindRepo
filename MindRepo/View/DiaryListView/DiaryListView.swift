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
    
    @State var year = Calendar.current.component(.year, from: .now)
    @State var month = Calendar.current.component(.month, from: .now)
    @State var showPicker: Bool = false
    @State var selection = Date()
    
    var body: some View {
        VStack {
            // Title
            HStack() {
                Text("일기목록")
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Button {
                    showPicker = true
                } label: {
                    Text("\(year.formatted(.number.grouping(.never)))년 \(month)월")
                }
                .sheet(isPresented: $showPicker) {
                    CustomYearMonthPickerView(year: $year, month: $month) {
                        showPicker = false
                    }
                }
                .presentationDetents([.height(300)])
            }
            .padding(.horizontal)
            .padding(.bottom)
            // ScrollView로 목록 구현
            ScrollView(showsIndicators: false){
                ForEach(items) { diary in
                    Button {
                        // 작성 중 내용으로 가면됨
                    } label: {
                        // 배경
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(minHeight: 100)
                                .foregroundStyle(.gray.opacity(0.1))
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(diary.mood.emoji)
                                        .font(.title)
                                    
                                    VStack(alignment: .leading) {
                                        Text(diary.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                                            .bold()
                                        Text("시간")
                                            .font(.footnote)
                                    }
                                }
                                .frame(maxWidth: .infinity , alignment: .topLeading)
                                .padding(.top, 10)
                                .padding(.bottom, 5)
                                
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("안녕하세요 지금은 테스트 중입니다.반갑습니다.")
                                        .foregroundStyle(.cyan)
                                        .lineLimit(1)
                                    Text("안녕하세요 지금은 테스트 중입니다.반갑습니다.")
                                        .foregroundStyle(.cyan)
                                        .lineLimit(1)
                                    Text("안녕하세요 지금은 테스트 중입니다.반갑습니다.")
                                        .foregroundStyle(.cyan)
                                        .lineLimit(1)
                                    
                                }
                                .padding(.vertical, 10)
                                .frame(maxWidth: 270, alignment: .leading)
                            }
                            .padding(.horizontal, 10) // 좌우 여백도 통일
                        }
                        .padding(.horizontal)
                        .foregroundStyle(.black)
                    } // label 끝
                }
            }
        }
        .background(.cyan.opacity(0.01))
    }
}

#Preview(traits: .diarySample) {
    DiaryListView()
}
