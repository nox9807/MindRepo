//
//  DiaryView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/16/25
//


import SwiftUI
enum AppColor {
    
}
struct DiaryView: View {
    let diary: Diary
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .frame(minHeight: 100)
                .foregroundStyle(.gray.opacity(0.1))
            
            VStack(alignment: .leading) {
                HStack {
                    Text(diary.mood.emojis)
                        .font(.title)
                    
                    VStack(alignment: .leading) {
                        Text(diary.date, format: Date.FormatStyle(date: .numeric, time: .omitted))
                            .bold()
                        Text(diary.date.formattedYMD_ko)
                            .font(.footnote)
                    }
                }
                .frame(maxWidth: .infinity , alignment: .topLeading)
                .padding(.top, 10)
                .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(diary.content)
                        .lineLimit(1)
                }
                .padding(.vertical, 10)
                .frame(maxWidth: 270, alignment: .leading)
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal)
        .foregroundStyle(.black)
    }
}

#Preview {
    DiaryView(diary: Diary.dummy[0])
}
