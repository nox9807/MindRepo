//
//  MoodStats.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//


import SwiftUI
import Charts

struct MoodStatView: View {
    let diaries: [Diary]
    
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
        VStack(spacing: 20) {
        
            Text("기본통계")
                .font(.title)
                .frame(alignment: .topTrailing)
            
            Text("감정별 (총 \(total)건)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // 감정별 카운트 리스트
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 16) {
                ForEach(moodCounts, id: \.0) { mood, count in
                    VStack(spacing: 6) {
                        Text(mood.emoji)
                            .font(.system(size: 28))
                        Text("\(count)")
                            .font(.headline)
                            .foregroundColor(count > 0 ? .primary : .gray)
                    }
                }
            }
            .padding(.horizontal)
            
            // 파이 차트
            if total > 0 {
                Chart {
                    ForEach(chartData, id: \.0) { mood, ratio in
                        SectorMark(
                            angle: .value("비율", ratio),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(color(for: mood))
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
    }
    
    // 감정별 색상 매핑
    private func color(for mood: Mood) -> Color {
        switch mood {
            case .angry: return .red
            case .sad: return .blue
            case .laugh: return .green
            case .neutral: return .gray
            case .bad: return .black
            case .good: return .yellow
        }
    }
}

#Preview {
    MoodStatView(diaries: Diary.dummy)
}
