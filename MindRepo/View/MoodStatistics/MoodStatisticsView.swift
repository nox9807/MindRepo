//
//  MoodStatiticsViews.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//

import SwiftData
import SwiftUI
import Charts

struct MoodStatisticsView: View {
    
    @Query(sort: [SortDescriptor(\Diary.date, order: .reverse)])
    private var diaries: [Diary]
    
    // 감정별 카운트 계산
    private var moodCounts: [(Mood, Int)] {
        Mood.allCases.map { mood in
            (mood, diaries.filter { $0.mood == mood }.count)
        }
    }
    
    // 총 일기 수
    private var total: Int {
        diaries.count
    }
    
    // 파이차트 데이터
    private var chartData: [(Mood, Double)] {
        moodCounts
            .filter { $0.1 > 0 }
            .map { ($0.0, Double($0.1) / Double(total)) }
    }
    
    var body: some View {
        NavigationStack{
            VStack {
                // MARK: 타이틀 아래 공백
                Spacer()
                    .frame(height: 60)
                
                // MARK: 감정별과 파이차트
                VStack {
                    
                    Text("감정별 (총 \(total)건)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    
                    // 감정별 카운트 리스트
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 16) {
                        ForEach(moodCounts, id: \.0) { mood, count in
                            VStack(spacing: 6) {
                                Text(mood.emojis)
                                    .font(.title3)
                                Text("\(count)")
                                    .font(.headline)
                                    .foregroundColor(count > 0 ? .primary : .gray)
                            }
                        }
                    }
                    
                    
                    // 파이 차트
                    if total > 0 {
                        Chart {
                            ForEach(chartData, id: \.0) { mood, ratio in
                                SectorMark(
                                    angle: .value("비율", ratio),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 1.2
                                )
                                .foregroundStyle(mood.color.opacity(0.6))
                                .cornerRadius(4)
                                .annotation(position: .overlay) {
                                    VStack{
                                        Text(mood.emojis)
                                            .font(.title3)
                                        
                                        Text("\(Int(ratio * 100))%")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                        .chartLegend(.hidden)
                        .padding()
                    } else {
                        Text("데이터가 없습니다.")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding()
                .navigationTitle("기본통계")
                
                // MARK: 파이차트 아래 공백
                Spacer()
                
            }
        }
    }
}
#Preview(traits: .diarySample) {
    MoodStatisticsView()
    
}


