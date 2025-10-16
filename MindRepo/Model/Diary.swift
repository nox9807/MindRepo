//
//  Diary.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Diary
@Model
final class Diary {
    var content: String
    var date: Date
    var createdAt: Date
    var updatedAt: Date
    var mood: Mood
    
    init(content: String, mood: Mood, date: Date = .now) {
        self.content = content
        self.date = date
        self.createdAt = .now
        self.updatedAt = .now
        self.mood = mood
    }
}

/// 화남, 슬픔, 웃음, 보통, 나쁨, 좋음
enum Mood: Int, CaseIterable, Codable, Sendable {
    case angry, sad, laugh, neutral, bad, good
    
    var title: String {
        switch self {
        case .angry: "화남"
        case .sad: "슬픔"
        case .laugh: "웃음"
        case .neutral: "보통"
        case .bad: "나쁨"
        case .good: "좋음"
        }
    }
    
    var emoji: String {
        switch self {
        case .angry: "😡"
        case .sad: "😢"
        case .laugh: "😄"
        case .neutral: "😐"
        case .bad: "☹️"
        case .good: "🙂"
        }
    }
}

/// Preview 전용 더미 데이터
extension Diary {
    static var dummy: [Diary] {
        [
            Diary(content: "평범한 하루를 보냈다.", mood: .neutral, date: .now.addingTimeInterval(-259200)),
            Diary(content: "화나는 일이 있었다.", mood: .angry, date: .now.addingTimeInterval(-172800)),
            Diary(content: "조금 우울한 하루다.", mood: .sad, date: .now.addingTimeInterval(-86400)),
            Diary(content: "오늘은 기분이 좋았다!", mood: .good, date: .now),
        ]
    }
}

/// SwiftData에 dummy 데이터를 삽입하는 메서드
extension Diary {
    @MainActor
    static func makeSampleData(in container: ModelContainer) {
        let context = ModelContext(container)
        
        let existing = (try? context.fetch(FetchDescriptor<Diary>())) ?? []
        guard existing.isEmpty else { return }
        
        dummy.forEach { context.insert($0) }
        try? context.save()
    }
}

extension Diary {
    var color: Color {
        switch mood {
            case .angry: return .red
            case .sad: return .black
            case .laugh: return .cyan
            case .neutral: return .orange
            case .bad: return .gray
            case .good: return . green
        }
    }
}
extension Mood {
    var emojis: Image {
        switch self {
            case .angry:
                Image("angry")
            case .sad:
                Image("sad")
            case .laugh:
                Image("laugh")
            case .neutral:
                Image("neutral")
            case .bad:
                Image("bad")
            case .good:
                Image("good")
        }
    }
}
