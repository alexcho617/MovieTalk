//
//  Extensinos.swift
//  MovieTalk
//
//  Created by Alex Cho on 12/11/23.
//

import Foundation
import UIKit
import Kingfisher

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

extension KingfisherManager{
    static func getRequestModifier() -> AnyModifier{
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(Secret.key, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.currentToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        return imageDownloadRequest
    }
}
