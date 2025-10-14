//
//  PreviewTrait+.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//

import SwiftUI
import SwiftData

/// SwiftUI #Preview(traits:) 에서 ModelContainer 를 쉽게 주입하기 위한 확장
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var diarySample: Self = .modifier(DiarySampleData())
}

// MARK: - DiarySampleData

fileprivate struct DiarySampleData: PreviewModifier {
    /// Preview에서 사용할 ModelContainer 생성 + 샘플 데이터 주입
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Diary.self, configurations: config)
        /// 샘플 데이터 주입 - Diary.dummy를 컨테이너에 주입함
        Diary.makeSampleData(in: container)
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}
