//
//  MainTabView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//


import SwiftUI

// MARK: - MainView

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @State var manager: EditorSheetManager = .shared
    @State var selected: TabItem = .list
    
    var body: some View {
        tabView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                tabbarView
                    .background(.ultraThinMaterial)
                    .overlay (
                        Color.appNavWash.opacity(0.20)
                            .blendMode(.overlay)
                            .allowsHitTesting(false) // overlay를 하면 터치가 안되는걸 되게하는 모디파이어
                    )
            }
            .ignoresSafeArea(edges: .bottom)
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
            .environment(manager)
    }
    
    @ViewBuilder
    private var tabView: some View {
        switch selected {
        case .list:
            DiaryListView()
        case .calendar:
            CalendarView(modelContext: modelContext)
        case .stats:
            MoodStatisticsView()
        }
    }
    
    private var tabbarView: some View {
        VStack() {
            Divider()
            
            HStack {
                Spacer()
                ForEach(TabItem.allCases, id: \.self) { item in
                    Spacer()
                    TabBarButton(item: item, selected: $selected)
                    Spacer()
                }
                Spacer()
            }
            .frame(maxHeight: 60)
            .padding(.bottom)
        }
    }
}

// MARK: - TabBarButton

fileprivate struct TabBarButton: View {
    let item: TabItem
    @Binding var selected: TabItem
    
    var body: some View {
        Button {
            selected = item
        } label: {
            VStack {
                Image(systemName: item.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                
                Text(item.title)
                    .font(.caption)
            }
        }
        .foregroundStyle(item == selected ? .primary : .secondary)
        .bold(item == selected)
    }
}

#Preview(traits: .diarySample) {
    MainView(selected: .list)
}
