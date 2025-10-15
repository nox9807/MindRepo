//
//  MainTabView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/15/25
//


import SwiftUI

enum Tab {
    case list
    case calendar
    case editor
    case stats
}

struct MainTabView: View {
    
    @State var selected: Tab = .list
    var basicColor: Color = .black
    var selectedColor: Color = .indigo
    
    var body: some View {
        // MARK : tabBar 아래 고정
        tabBar
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                VStack() {
                    Divider()
                    
                    tabButton
                }
                .background(.ultraThinMaterial)
            }
            .ignoresSafeArea(edges: .bottom)
    }
    // tabBar 화면 전환
    @ViewBuilder
    var tabBar: some View {
        switch selected {
            case .list:
                DiaryListView()
            case .calendar:
                Text("calendarView")
            case .editor:
                DiaryEditorView()
            case .stats:
                MoodStat()
        }
        
    }
    // tabButton 기능
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
                    
                    Text("일기목록")
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
                    
                    Text("기분달력")
                        .font(.caption)
                }
            }
            .foregroundStyle(selected == .calendar ? selectedColor : basicColor)
            .bold(selected == .calendar)
            
            Spacer()
            
            Button {
                selected = .editor
            } label: {
                VStack {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("일기작성")
                        .font(.caption)
                }
            }
            .foregroundStyle(selected == .editor ? selectedColor : basicColor)
            .bold(selected == .editor)
            
            Spacer()
            
            Button {
                selected = .stats
            } label: {
                VStack {
                    Image(systemName: "chart.pie")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text("기분통계")
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

#Preview {
    MainTabView(selected: .list)
}

// 탭 뷰 다른 방식
//        TabView {
//            DiaryListView()
//                .tabItem {
//                    Image(systemName: "document.fill")
//                    Text("일기목록")
//                }
//            Text("기분달력")
//                .tabItem {
//                    Image(systemName: "document.fill")
//                    Text("기분달력")
//                }
//            Text("일기작성1")
//                .tabItem {
//                    Image(systemName: "document.fill")
//                    Text("기분달력")
//                }
//            MoodStat()
//                .tabItem {
//                    Image(systemName: "document.fill")
//                    Text("기분통계")
//                }
//        }
