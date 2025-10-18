//
//  ContentView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25.
//

import SwiftUI
import SwiftData

// MARK: - 예시
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Diary]
    
    /// 데이터 추가
    private func addDiary() {
        let randomMood = Mood.allCases.randomElement() ?? .neutral
        let newDiary = Diary(
            content: "오늘 내 기분은 \(randomMood.title).",
            mood: randomMood
        )
        modelContext.insert(newDiary)
    }
    
    /// 데이터 삭제
    private func deleteDiary(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { diary in
                    NavigationLink {
                        navigationView(diary)
                            .padding()
                    } label: {
                        navigationRow(diary)
                    }
                }
                .onDelete(perform: deleteDiary)
            }
            .navigationTitle("예시 뷰")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addDiary) {
                        Label("추가", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    /// 네비게이션 링크의 행 뷰
    private func navigationRow(_ diary: Diary) -> some View {
        HStack {
            Text(diary.mood.emoji)
            VStack(alignment: .leading) {
                Text(diary.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                Text(diary.content)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
    }
    
    /// 네비게이션 링크의 상세 뷰
    private func navigationView(_ diary: Diary) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(diary.mood.emoji)
                .font(.largeTitle)
            Text(diary.date, style: .date)
            Text(diary.content)
            Spacer()
        }
    }
}

// MARK: - SwiftData Preview 이용 방법
/// Preview(traits:)에 diarySample를 전달하면 샘플 데이터가 포함된 ModelContainer가 주입
/// PreviewTrait+.swift 참고
#Preview(traits: .diarySample) {
    ContentView()
}
/// traits을 이용하지 않는 경우, 직접 ModelContainer를 생성하여 주입
#Preview {
    let container: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Diary.self, configurations: config)
            Diary.makeSampleData(in: container)
            return container
        } catch {
            fatalError("Preview를 위한 ModelContainer 생성에 실패했습니다: \(error.localizedDescription)")
        }
    }()
    
    return ContentView()
        .modelContainer(container)
}
