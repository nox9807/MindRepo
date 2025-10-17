//
//  CommonLayoutView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/17/25
//


import SwiftUI

struct CommonLayoutView<Header: View, Content: View>: View {
    @ViewBuilder var header: () -> Header
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: - 타이틀 부분
            
            header()
            
            // MARK: - 전달 뷰 부분
            
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

#Preview {
    CommonLayoutView {
        Text("네비게이션")
            .font(.largeTitle)
        Text("부제목")
            .font(.title2)
            .foregroundStyle(.secondary)
    } content: {
            Text("본문")
            Text("본문")
            Text("본문")
            Text("본문")
    }
}