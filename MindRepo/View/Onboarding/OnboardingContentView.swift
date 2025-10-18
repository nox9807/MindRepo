//
//  OnboardingContent.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/18/25
//


import SwiftUI

struct OnboardingContent: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding(.top, 60)
            
            Text(title)
                .font(.title)
                .bold()
            
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
