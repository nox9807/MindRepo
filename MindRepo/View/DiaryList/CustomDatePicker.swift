//
//  CustomDatePicker.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/17/25
//


import SwiftUI

struct CustomDatePicker: View {
    @Binding var year: Int
    @Binding var month: Int
    var onDone: () -> Void = {}
    
    let years = Array(2022...2035)
    let months = Array(1...12)
    
    var body: some View {
        VStack {
            Text("선택하실 년도와 월을 고르세요.")
                .font(.headline)
            
            HStack {
                Picker("Year", selection: $year) {
                    ForEach(years, id: \.self) {
                        Text("\($0.formatted(.number.grouping(.never)))년").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Month", selection: $month) {
                    ForEach(months, id: \.self) {
                        Text("\($0)월").tag($0)
                    }
                }
                .pickerStyle(.wheel)
            }
            .frame(height: 170)
            
            Button("완료", action: onDone)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
