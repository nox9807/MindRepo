//
//  MainTabView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//


import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @State var selected: TabItem = .list
    var basicColor: Color = .black
    var selectedColor: Color = .indigo
    
    @State var showSheet = false
    
    func showPlusSheet() {
        showSheet = true
    }
    
    var body: some View {
            // MARK: tabBar 아래 고정
            tabBar
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom) {
                    VStack() {
                        Divider()
                        
                        tabButton
                    }
                    .background(.ultraThinMaterial)
                    .overlay (
                        Color.appNavWash.opacity(0.20)
                            .blendMode(.overlay)
                            .allowsHitTesting(false) // overlay를 하면 터치가 안되는걸 되게하는 모디파이어
                    )
                }
                .ignoresSafeArea(edges: .bottom)
                .sheet(isPresented: $showSheet) {
                    DiaryEditorView()
                }
    }
        
    // MARK: -tabBar 화면 전환
    @ViewBuilder
    var tabBar: some View {
        switch selected {
            case .list:
                DiaryListView(action: showPlusSheet)
            case .calendar:
                CalendarView(modelContext: modelContext)
            case .stats:
                MoodStatisticsView()
        }
    }
    
    // MARK: -tabButton 기능
    @ViewBuilder
    var tabButton: some View {
        HStack {
            Spacer()
            
            Button {
                selected = .list
            } label: {
                VStack {
                    Image(systemName: "document")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("목록")
                        .font(.caption)
                }
            }
            .foregroundStyle(selected == .list ? selectedColor : basicColor)
            .bold(selected == .list)
            
            Spacer()
            
            Button {
                selected = .calendar
            } label: {
                VStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("달력")
                        .font(.caption)
                }
            }
            .foregroundStyle(selected == .calendar ? selectedColor : basicColor)
            .bold(selected == .calendar)
            
            Spacer()
            
            Button {
                selected = .stats
            } label: {
                VStack {
                    Image(systemName: "chart.pie")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("통계")
                        .font(.caption)
                }
            }
            .foregroundStyle(selected == .stats ? selectedColor : basicColor)
            .bold(selected == .stats)
            
            Spacer()
            
        }
        .frame(maxHeight: 60)
        .padding(.bottom)
        
    }
    
}

#Preview(traits: .diarySample) {
    MainView(selected: .list)
}
