# MindRepo
📔 MindRepo란?

MindRepo는 사용자가 귀여운 이모티콘과 함께 일상을 기록하고, 감정필터와 통계 기능을 통해 회고와 분석이 가능하도록 설계된 iOS 다이어리 앱입니다.
📌 주요 기능

✍️ 다이어리 작성, 수정, 삭제 및 이모티콘 지정
📅 다이어리 리스트 와 다이어리 달력(감정별 날짜 표시)
🔍 필터링 (감정별)
📊 감정통계 (감정별 차트 제공)

## 브랜치
- dev 브랜치에서 개발 후 main 브랜치로 병합

📁 폴더 구조
```
📁 MindRepo
├ 📁 Extenstion                      
│   │   ├ 📝 Calendar+
│   │   ├ 📝 Date+
│   │   ├ 📝 PreviewTrait+
│   ├ 📁 Model
│   │   ├ 📝 Diary
│   ├ 📁 View         
│   │   └ 📁 Calendar
│   │   │   ├ 📝 CalendarDisplayModel
│   │   │   ├ 📝 CalendarView
│   │   │   ├ 📝 CalendarViewModel
│   │   │   ├ 📝 MonthlyCalendarView
│   │   └ 📁 Common
│   │   │   ├ 📝 CommonLayoutView
│   │   └ 📁 DiaryEditor
│   │   │   ├ 📝 DiaryEditorView
│   │   └ 📁 DiaryList
│   │   │   ├ 📝 CustomDatePicker // 현재 사용 x
│   │   │   ├ 📝 DiaryListView
│   │   │   ├ 📝 DiaryView
│   │   └ 📁 Main
│   │   │   ├ 📝 EditorSheetManager
│   │   │   ├ 📝 MainView
│   │   │   ├ 📝 TabItem
│   │   └ 📁 MoodStatistics
│   │   │   ├ 📝 MoodStatisticsView
│   │   └ 📁 Onboarding
│   │   │   ├ 📝 OnboardingContentView
│   │   │   ├ 📝 OnboardingView
```
## 📱 주요 뷰 화면

| 🏠 홈 화면 | 🔎 검색 화면 | ➕ 추가 화면 |
|---|---|---|
| <img width="301" height="623" alt="image" src="https://github.com/user-attachments/assets/84dd2063-680c-429c-8014-bc944d4ee38f" alt="홈 화면"> | <img width="305" height="623" alt="image" src="https://github.com/user-attachments/assets/9c933b8e-261c-4511-9c17-f40c95fbb996" alt="검색 화면"> |<img width="297" height="621" alt="image" src="https://github.com/user-attachments/assets/f62a49ac-d407-4466-918f-fe7d18296fe8" alt="추가 화면"> |

| 📅 달력 화면 | 📊 통계 화면 |
|---|---|
| <img width="303" height="624" alt="image" src="https://github.com/user-attachments/assets/c3883606-03d9-4adf-bc44-b406dfc84af8" alt="달력 화면"> | <img width="307" height="627" alt="image" src="https://github.com/user-attachments/assets/a525bf13-d6df-4c07-b5f5-186e4165e2fb" alt="통계 화면"> |
