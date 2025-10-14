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
    
    var body: some View {
        VStack {
            // Title
            HStack() {
                Text("일기목록")
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    
                } label: {
                    Text("2025년 4월")
                        .font(.caption2)
                        .bold()
                        .frame(maxWidth: 80, maxHeight: 20)
                        .overlay(
                            Capsule()
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)
            ScrollView(showsIndicators: false){
                ForEach(items) { diary in
                    Button {
                        
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
