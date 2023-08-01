//
//  RecongnizeStringRepository.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/29.
//

import Foundation

//class ExpiredParser {
//
//    private let dateFilterRegex: [NSRegularExpression] = [
//        try! NSRegularExpression(pattern: "(\\d{4})\\s*[-/년., ]+\\s*(\\d{1,2})\\s*[-/월., ]+\\s*(\\d{1,2})"),
//        try! NSRegularExpression(pattern: "\\b(\\d{8})\\b")
////        try! NSRegularExpression(pattern: "\\b(\\d{4})(\\d{2})(\\d{2})\\b"),
////        try! NSRegularExpression(pattern: "(\\d{4})\\s+(\\d{2})\\s+(\\d{2})"),
////        try! NSRegularExpression(pattern: "(\\d{4})+(\\d{2})\\s+(\\d{2})"),
////        try! NSRegularExpression(pattern: "(\\d{4})+(\\d{2})+(\\d{2})"),
////        try! NSRegularExpression(pattern: "(\\d{4})\\s+(\\d{2})+(\\d{2})"),
//    ]
//
//    private let expiredFilterRegex: [NSRegularExpression] = [
//        try! NSRegularExpression(pattern: "만료[^\\d]*(\\d*)일")
//    ]
//
////    private func parseDateFormat(inputs: [String]) -> ExpiredParserResult {
////        var dateList = [Date]()
////        var dateFiltered = [String]()
////
////        var queue = inputs
////
////        while !queue.isEmpty {
////            let text = queue.removeFirst()
////            var find: NSRange?
////            var matchedRegEx: NSRegularExpression?
////            for regex in dateFilterRegex {
////                if let range = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))?.range {
////                    find = range
////                    matchedRegEx = regex
////                    break
////                }
////            }
////
////            if find == nil {
////                dateFiltered.append(text)
////            } else {
////                guard let foundRange = find, let regex = matchedRegEx else { continue }
////
////                let components = regex.captureGroups(in: text)
////                guard let yearString = components.getOrNull(0), let year = Int(yearString), 2000...2100 ~= year else { continue }
////                guard let monthString = components.getOrNull(1), let month = Int(monthString), 1...12 ~= month else { continue }
////                guard let dayOfMonthString = components.getOrNull(2), let dayOfMonth = Int(dayOfMonthString), 1...31 ~= dayOfMonth else { continue }
////
////                let calendar = Calendar.current
////                let dateComponents = DateComponents(year: year, month: month, day: dayOfMonth, hour: 0, minute: 0, second: 0)
////                if let date = calendar.date(from: dateComponents) {
////                    dateList.append(date)
////                }
////
////                if let endDate = foundRange.length < text.count ? (foundRange.location + foundRange.length) : nil {
////                    queue.append(String(text[text.index(text.startIndex, offsetBy: endDate)...]))
////                }
////            }
////        }
////        return ExpiredParserResult(expired: dateList.max() ?? Date(timeIntervalSince1970: 0), filtered: dateFiltered)
////    }
//
//    private func parseDateFormat(inputs: [String]) -> ExpiredParserResult {
//        var dateList = [Date]()
//        var dateFiltered = [String]()
//
//        var queue = inputs
//
//        while !queue.isEmpty {
//            let text = queue.removeFirst()
//            var find: NSRange?
//            var matchedRegEx: NSRegularExpression?
//            for regex in dateFilterRegex {
//                if let range = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))?.range {
//                    find = range
//                    matchedRegEx = regex
//                    break
//                }
//            }
//
//            if find == nil {
//                   dateFiltered.append(text)
//               } else {
//                   guard let foundRange = find, let regex = matchedRegEx else { continue }
//
//                   var components = regex.captureGroups(in: text)
//
//                   if regex == dateFilterRegex[1] {
//                       guard let fullDate = components.getOrNull(0), let dateInt = Int(fullDate) else { continue }
//                       let year = dateInt / 10000
//                       let month = (dateInt % 10000) / 100
//                       let day = dateInt % 100
//
//                       components.removeAll()
//                       components.append("\(year)")
//                       components.append("\(month)")
//                       components.append("\(day)")
//                   }
//
//                   let year = Int(components[0]) ?? 0
//                   let month = Int(components[1]) ?? 0
//                   let dayOfMonth = Int(components[2]) ?? 0
//
//                   let calendar = Calendar.current
//                   let dateComponents = DateComponents(year: year, month: month, day: dayOfMonth, hour: 0, minute: 0, second: 0)
//                   if let date = calendar.date(from: dateComponents) {
//                       dateList.append(date)
//                   }
//
//                   if let endDate = foundRange.length < text.count ? (foundRange.location + foundRange.length) : nil {
//                       queue.append(String(text[text.index(text.startIndex, offsetBy: endDate)...]))
//                   }
//               }
//        }
//        return ExpiredParserResult(expired: dateList.max() ?? Date(timeIntervalSince1970: 0), filtered: dateFiltered)
//    }
//
//    private func parseExpiredFormat(inputs: [String]) -> ExpiredParserResult {
//        var dateList = [Date]()
//        var dateFiltered = [String]()
//
//        inputs.forEach { text in
//            var find: NSRange?
//            var matchedRegEx: NSRegularExpression?
//            for regex in expiredFilterRegex {
//                if let range = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))?.range {
//                    find = range
//                    matchedRegEx = regex
//                    break
//                }
//            }
//
//            if find == nil {
//                dateFiltered.append(text)
//            } else {
//                guard let regex = matchedRegEx else { return }
//                let components = regex.captureGroups(in: text)
//                guard let expiredDateString = components.getOrNull(0), let expiredDate = Int(expiredDateString) else { return }
//
//                let calendar = Calendar.current
//                let currentDate = Date()
//                if let date = calendar.date(byAdding: .day, value: expiredDate, to: currentDate) {
//                    dateList.append(date)
//                }
//            }
//        }
//        return ExpiredParserResult(expired: dateList.max() ?? Date(timeIntervalSince1970: 0), filtered: dateFiltered)
//    }
//
//    func parseExpiredDate(inputs: [String]) -> ExpiredParserResult {
//        let calendar = Calendar.current
//        let dateFormatResult = parseDateFormat(inputs: inputs)
//        let expiredFormatResult = parseExpiredFormat(inputs: dateFormatResult.filtered)
//        let expiredDate = dateFormatResult.expired > expiredFormatResult.expired ? dateFormatResult.expired : expiredFormatResult.expired
////        return ExpiredParserResult(expired: expiredDate, filtered: expiredFormatResult.filtered)
////        let expiredDateWithoutTime = calendar.dateWithoutTime(from: expiredDate) // Add this line
////        return ExpiredParserResult(expired: expiredDateWithoutTime, filtered: expiredFormatResult.filtered)
//        let expiredDateAtEndOfDay = calendar.dateAtEndOfDay(from: expiredDate) // Add this line
//        return ExpiredParserResult(expired: expiredDateAtEndOfDay, filtered: expiredFormatResult.filtered)
//    }
//
//}
//
//struct ExpiredParserResult {
//    let expired: Date
//    let filtered: [String]
//}
//
//extension NSRegularExpression {
//    func captureGroups(in text: String) -> [String] {
//        guard let match = self.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) else { return [] }
//        return (0..<numberOfCaptureGroups).compactMap { rangeIndex -> String? in
//            guard let range = Range(match.range(at: rangeIndex + 1), in: text) else { return nil }
//            return String(text[range])
//        }
//    }
//}
//
//extension Array {
//    func getOrNull(_ index: Int) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
//
////extension Calendar {
////    func dateWithoutTime(from date: Date) -> Date {
////        let components = self.dateComponents([.year, .month, .day], from: date)
////        return self.date(from: components) ?? date
////    }
////}
//
//extension Calendar {
//    func dateAtEndOfDay(from date: Date) -> Date {
//        var components = self.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        components.hour = 23
//        components.minute = 59
//        components.second = 59
//        components.timeZone = TimeZone.current // Considering timezone
//        return self.date(from: components) ?? date
//    }
//}

class ExpiredParser {
    
    private let dateFilterRegex: [NSRegularExpression] = [
        try! NSRegularExpression(pattern: "(\\d{4})\\s*[-/년., ]+\\s*(\\d{1,2})\\s*[-/월., ]+\\s*(\\d{1,2})"),
        try! NSRegularExpression(pattern: "\\b(\\d{8})\\b")
    ]
    
    private let expiredFilterRegex: [NSRegularExpression] = [
        try! NSRegularExpression(pattern: "만료[^\\d]*(\\d*)일")
    ]
    
    private func parseDateFormat(inputs: [String]) -> ExpiredParserResult {
        var dateList = [Date]()
        var dateFiltered = [String]()
        
        inputs.forEach { text in
            var find: NSRange?
            var matchedRegEx: NSRegularExpression?
            for regex in dateFilterRegex {
                if let range = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))?.range {
                    find = range
                    matchedRegEx = regex
                    break
                }
            }
            
//            guard let foundRange = find, let regex = matchedRegEx else {
//                dateFiltered.append(text)
//                return
//            }
            if find == nil {
                dateFiltered.append(text)
            } else {
                guard let regex = matchedRegEx else { return }
                var components = regex.captureGroups(in: text)
                
                if regex == dateFilterRegex[1] {
                    guard let fullDate = components.getOrNull(0), let dateInt = Int(fullDate) else { return }
                    let year = dateInt / 10000
                    let month = (dateInt % 10000) / 100
                    let day = dateInt % 100
                    components = ["\(year)", "\(month)", "\(day)"]
                }
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy MM dd HH mm ss"
                
                let dateStr = "\(components[0]) \(components[1]) \(components[2]) 23 59 59"
                if let date = dateFormat.date(from: dateStr) {
                    dateList.append(date)
                }
            }
        }
        
        return ExpiredParserResult(expired: dateList.max() ?? Date(timeIntervalSince1970: 0), filtered: dateFiltered)
    }
    
    private func parseExpiredFormat(inputs: [String]) -> ExpiredParserResult {
        var dateList = [Date]()
        var dateFiltered = [String]()
        
        inputs.forEach { text in
            var find: NSRange?
            var matchedRegEx: NSRegularExpression?
            for regex in expiredFilterRegex {
                if let range = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))?.range {
                    find = range
                    matchedRegEx = regex
                    break
                }
            }
            
            if find == nil {
                dateFiltered.append(text)
            } else {
                guard let regex = matchedRegEx else { return }
                let components = regex.captureGroups(in: text)
                guard let expiredDateString = components.getOrNull(0), let expiredDate = Int(expiredDateString) else { return }
                
                let currentDate = Date()
                let expireInterval = TimeInterval(expiredDate * 86400)
                let expiredDateObject = currentDate.addingTimeInterval(expireInterval)
                
                dateList.append(expiredDateObject)
            }
        }
        
        return ExpiredParserResult(expired: dateList.max() ?? Date(timeIntervalSince1970: 0), filtered: dateFiltered)
    }
    
    func parseExpiredDate(inputs: [String]) -> ExpiredParserResult {
        let dateFormatResult = parseDateFormat(inputs: inputs)
        let expiredFormatResult = parseExpiredFormat(inputs: dateFormatResult.filtered)
        let expiredDate = dateFormatResult.expired > expiredFormatResult.expired ? dateFormatResult.expired : expiredFormatResult.expired
        return ExpiredParserResult(expired: expiredDate, filtered: expiredFormatResult.filtered)
    }
}

struct ExpiredParserResult {
    let expired: Date
    let filtered: [String]
}

extension NSRegularExpression {
    func captureGroups(in text: String) -> [String] {
        guard let match = self.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) else { return [] }
        return (0..<numberOfCaptureGroups).compactMap { rangeIndex -> String? in
            guard let range = Range(match.range(at: rangeIndex + 1), in: text) else { return nil }
            return String(text[range])
        }
    }
}

extension Array {
    func getOrNull(_ index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
