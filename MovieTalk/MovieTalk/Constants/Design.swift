//
//  Design.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/24/23.
//

import UIKit

enum Design{
    static let paddingDefault: CGFloat = 8.0
    
    static let colorTextTitle = UIColor.white
    static let colorTextSubTitle = UIColor.lightGray
    static let colorTextDefault = UIColor.label
    static let colorBlack = UIColor.black
    static let colorGray = UIColor.systemGray.withAlphaComponent(0.8)
    
    static let fontTitle: UIFont = .systemFont(ofSize: 20, weight: .bold)
    static let fontSubTitle: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    static let fontAccentDefault: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    static let fontDefault: UIFont = .systemFont(ofSize: 14, weight: .medium)
    static let fontSmall: UIFont = .systemFont(ofSize: 12, weight: .light)

    static let debugPink = UIColor.systemPink.withAlphaComponent(0.5)
    static let debugBlue = UIColor.systemBlue.withAlphaComponent(0.5)
    static let debugGray = UIColor.systemGray.withAlphaComponent(0.5)

}

extension UIColor{
    static func random() -> UIColor{
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: .random(in: 0.4...0.9))
    }
}

extension DateFormatter {
    static func localizedDateString(fromTimestampString timestampString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", localeIdentifier: String = "ko_KR") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: timestampString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = Locale(identifier: localeIdentifier)
            outputDateFormatter.dateStyle = .short
            outputDateFormatter.timeStyle = .short

            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    static func movieYear(fromReleaseDateString releaseDateString: String, inputFormat: String = "yyyy-MM-dd", outputFormat: String = "yyyy") -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat

            if let date = dateFormatter.date(from: releaseDateString) {
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = outputFormat
                return outputDateFormatter.string(from: date)
            } else {
                return nil
            }
        }
}
