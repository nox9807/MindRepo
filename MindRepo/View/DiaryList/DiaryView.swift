//
//  DiaryView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/16/25
//


import SwiftUI

struct DiaryView: View {
    let diary: Diary
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .frame(minHeight: 100)
                .foregroundStyle(Color.appCard)
                .shadow(radius: 3, y: 3)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(diary.mood.emojis)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text(diary.date.formattedYMD_ko)
                            .bold()
                        Text(diary.date.formattedHM_ko)
                            .font(.footnote)
                    }
                    .foregroundStyle(Color.textPrimary)
                }
                .frame(maxWidth: .infinity , alignment: .topLeading)
                .padding(.top, 10)
                .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(diary.content)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(1)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: 270, alignment: .leading)
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal)
        //.background(Color.appBackground.opacity(0.95))
    }
}

#Preview {
    DiaryView(diary: Diary.dummy[0])
}
