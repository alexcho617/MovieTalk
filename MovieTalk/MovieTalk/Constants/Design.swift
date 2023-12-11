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

