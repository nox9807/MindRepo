//
//  OnboardingView.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/17/25
//


import SwiftUI

// TODO: - 파일나누기, 이름 page->content
struct OnboardingView: View {
    @State private var currentPage = 0
    let totalPages = 3
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPage(
                    image: "onboarding1",
                    title: "하루의 기분, 이모티콘 하나로 표현해요",
                    description: "기쁜 날, 힘든 날, 평범한 날까지 — 당신의 마음을 솔직하게 기록해보세요"
                ).tag(0)
                
                OnboardingPage(
                    image: "onboarding2",
                    title: "감정의 달력을 펼쳐보세요",
                    description: "매일 쌓인 감정들이 달력 위에 펼쳐집니다. 지난날의 나를 따뜻하게 돌아보세요"
                ).tag(1)
                
                OnboardingPage(
                    image: "onboarding3",
                    title: "감정의 흐름을 데이터로",
                    description: "감정 통계를 통해 나의 마음 변화를 객관적으로 확인해보세요"
                ).tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .animation(.easeInOut, value: currentPage)
            
            // 페이지 인디케이터 + 버튼
            HStack {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.vertical, 20)
            
            Button(action: {
                if currentPage < totalPages - 1 {
                    currentPage += 1
                } else {
                    // 온보딩 완료 후 처리 (예: UserDefaults로 상태 저장)
                    UserDefaults.standard.set(true, forKey: "didOnboard")
                }
            }) {
                Text(currentPage < totalPages - 1 ? "다음" : "시작하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 30)
        }
        .multilineTextAlignment(.center)
    }
}

struct OnboardingPage: View {
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
