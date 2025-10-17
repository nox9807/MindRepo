//
//  EditorSheetManager.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/17/25
//


import SwiftUI

/// `EditorSheetManager`는 새로운 일기 작성 또는 기존 일기 편집 시
/// 적절한 시트를 표시하기 위한 상태를 보관하고, 시트를 띄우는 메서드를 제공함.
///
/// - Note: SwiftUI의 `sheet(item:)` modifier에서 `sheetItem`을 바인딩하여
/// 자동으로 표시 상태를 연동하도록 설계되어 있음.
@Observable
final class EditorSheetManager {
    
    /// 시트의 종류를 나타내는 타입.
    ///
    /// - `newDiaryToday`: 오늘 일기 작성용 시트.
    /// - `newDiaryAt`: 특정 날짜의 일기 작성용 시트.
    /// - `editDiary`: 기존 일기 편집용 시트. 편집할 `Diary` 모델을 전달함.
    enum SheetType: Identifiable {
        case newDiaryToday
        case newDiaryAt(Date)
        case editDiary(Diary)
        
        var id: String {
            switch self {
            case .newDiaryToday:
                return "newDiaryToday"
            case .newDiaryAt(let date):
                return "newDiary_\(date.timeIntervalSince1970)"
            case .editDiary(let diary):
                return "editDiary_\(diary.id)"
            }
        }
    }
    
    /// `sheet(item:)`에 바로 넘길 수 있는 바인딩.
    var sheetItemBinding: Binding<SheetType?> {
        Binding(
            get: { self.sheetItem },
            set: { self.sheetItem = $0 }
        )
    }
    
    /// 현재 표시 중인 시트의 상태.
    ///
    /// `nil`이면 시트가 닫혀 있으며,
    /// `SheetType`이 설정되면 해당 타입에 맞는 시트를 표시함.
    private(set) var sheetItem: SheetType? = nil
    
    /// 새 일기 작성 시트를 표시함.
    ///
    /// - Parameter date: 특정 날짜를 지정할 수 있음. 기본값은 `nil`.
    /// - Example:
    ///   ```swift
    ///   manager.presentNewDiary(on: Date())
    ///   ```
    func presentNewDiary(on date: Date? = nil) {
        if let date {
            sheetItem = .newDiaryAt(date)
        } else {
            sheetItem = .newDiaryToday
        }
    }
    
    /// 기존 일기 편집 시트를 표시함.
    ///
    /// - Parameter diary: 편집할 일기 모델.
    /// - Example:
    ///   ```swift
    ///   manager.presentEditDiary(diary)
    ///   ```
    func presentEditDiary(_ diary: Diary) {
        sheetItem = .editDiary(diary)
    }
}


#Preview {
    @Previewable @State var manager = EditorSheetManager()
    
    VStack {
        VStack {
            Button("오늘 새 일기 작성 시트 열기") {
                manager.presentNewDiary()
            }
            
            Button("특정 날짜 새 일기 작성 시트 열기") {
                manager.presentNewDiary(on: Date().addingTimeInterval(-86400 * 3))
            }
            
            Button("기존 일기 편집 시트 열기") {
                manager.presentEditDiary(Diary.dummy[0])
            }
        }
        .sheet(item: manager.sheetItemBinding) { item in
            switch item {
            case .newDiaryToday:
                DiaryEditorView()
            case .newDiaryAt(let date):
                DiaryEditorView(date: date)
            case .editDiary(let diary):
                DiaryEditorView(diary: diary)
            }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
