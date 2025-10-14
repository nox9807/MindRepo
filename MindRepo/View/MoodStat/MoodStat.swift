//
//  MoodStat.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25
//


import SwiftUI

struct MoodStat: View {
    
    @State var String = ["angry", "sad", "laugh", "neutral", "sad", "bad"]
    @State var count: Int = 0
    

    
    var body: some View {
        
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            
            VStack() {
                Text("기분 통계")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity,alignment: .topLeading)
                    .padding(.leading)
                
                Text("전체 (총건) 중")
                
                
                HStack(spacing:80) {
                    Text(Mood.angry.emoji)
                    
                    Text(Mood.angry.emoji)
                    
                    Text(Mood.angry.emoji)
                }
                .padding()
                
                
                    HStack(spacing:80) {
                        Text(Mood.angry.emoji)
                        
                        Text(Mood.angry.emoji)
                        
                        Text(Mood.angry.emoji)
                        
                    
                    
                    
                }
            }
        }
        
        
    }
}

#Preview {
    MoodStat()
}
