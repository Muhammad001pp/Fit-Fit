//
//  TrainingCalendarView.swift
//  FitDesk
//
//  Created by Copilot on 25/08/2025.
//

import SwiftUI

struct TrainingCalendarView: View {
    @State private var month: Date = .now
    
    // Dummy data for workout progress
    private var workoutData: [Date: Double] {
        let calendar = Calendar.current
        var data: [Date: Double] = [:]
        // Generate some data for demonstration
        for i in -15...15 {
            if let date = calendar.date(byAdding: .day, value: i, to: .now) {
                let dayComponent = calendar.component(.day, from: date)
                if dayComponent % 5 == 1 {
                    data[calendar.startOfDay(for: date)] = 1.0 // 100%
                } else if dayComponent % 5 == 2 {
                    data[calendar.startOfDay(for: date)] = Double.random(in: 0.2..<0.8) // Partial
                } else if dayComponent % 5 == 3 {
                     data[calendar.startOfDay(for: date)] = 0.49 // low
                }
            }
        }
        return data
    }
    
    var body: some View {
        VStack {
            headerView
            daysOfWeekView
            calendarGridView
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                self.month = Calendar.current.date(byAdding: .month, value: -1, to: self.month) ?? self.month
            }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            Text(month, formatter: DateFormatter.monthYearFormatter)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                self.month = Calendar.current.date(byAdding: .month, value: 1, to: self.month) ?? self.month
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.bottom, 8)
    }
    
    private var daysOfWeekView: some View {
        HStack {
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                Text(day.prefix(2).uppercased())
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var calendarGridView: some View {
        let days = generateDaysInMonth(for: month)
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            ForEach(0..<days.count, id: \.self) { index in
                if let date = days[index] {
                    let progress = workoutData[Calendar.current.startOfDay(for: date)]
                    CalendarDayView(day: Calendar.current.component(.day, from: date), progress: progress)
                } else {
                    Rectangle().fill(Color.clear)
                }
            }
        }
    }
    
    private func generateDaysInMonth(for date: Date) -> [Date?] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let weekdayOffset = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: weekdayOffset)
        
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: date)!.count
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(bySetting: .day, value: day, of: date) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
}

struct CalendarDayView: View {
    let day: Int
    let progress: Double? // 0.0 to 1.0
    
    private var progressColor: Color {
        guard let progress = progress else { return .clear }
        if progress >= 1.0 { return .green }
        if progress > 0.5 { return .yellow }
        return .red
    }
    
    private var backgroundColor: Color {
        progressColor.opacity(0.3)
    }
    
    var body: some View {
        Text("\(day)")
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .padding(4)
            .background(
                ZStack {
                    if progress != nil {
                        Circle()
                            .fill(backgroundColor)
                        
                        Circle()
                            .trim(from: 0, to: progress ?? 0)
                            .stroke(progressColor, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .padding(1)
                    }
                }
            )
            .clipShape(Circle())
    }
}

extension DateFormatter {
    static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}

extension Calendar {
    func isDate(_ date1: Date, inSameMonthAs date2: Date) -> Bool {
        self.isDate(date1, equalTo: date2, toGranularity: .month)
    }
}

