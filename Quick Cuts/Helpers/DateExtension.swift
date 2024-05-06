import Foundation

extension Date {
    
    enum DateFormat {
        case custom(String)
    }
    
    // MARK: - Intervals In Seconds
    private static func minuteInSeconds() -> Double { return 60 }
    private static func hourInSeconds() -> Double { return 3600 }
    private static func dayInSeconds() -> Double { return 86400 }
    private static func weekInSeconds() -> Double { return 604800 }
    private static func yearInSeconds() -> Double { return 31556926 }
    
    // MARK: - Components
    private static func componentFlags() -> NSCalendar.Unit {
        // swiftlint:disable line_length
        return NSCalendar.Unit.year.union(NSCalendar.Unit.month).union(NSCalendar.Unit.day).union(NSCalendar.Unit.hour).union(NSCalendar.Unit.minute).union(NSCalendar.Unit.second).union(NSCalendar.Unit.weekday).union(NSCalendar.Unit.weekdayOrdinal).union(NSCalendar.Unit.weekOfYear)
        // swiftlint:enable line_length
    }
    
    private static func components(fromDate: Date) -> DateComponents! {
        return (Calendar.current as NSCalendar).components(Date.componentFlags(), from: fromDate)
    }
    
    private func components() -> DateComponents {
        return Date.components(fromDate: self)!
    }
    
    // MARK: - Adjusting Dates
    func dateByAddingDays(_ days: Int) -> Date {
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate + Date.dayInSeconds() * Double(days)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingDays(_ days: Int) -> Date {
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - Date.dayInSeconds() * Double(days)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateAtStartOfDay() -> Date {
        var components = self.components()
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components)!
    }
    
    // MARK: - List of Dates
    func arrayOfdatesTill(_ endDate: Date) -> [Date] {
        var dates = [Date]()
        var startDate = self
        while startDate <= endDate {
            let date = startDate.dateByAddingDays(1)
            dates.append(date)
            startDate = startDate.dateByAddingDays(1)
        }
        
        return dates
    }
    
    // MARK: - Format Date
    func getMonthFromDate(format: String = "MMM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func getDayFromDate(format: String = "d") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
