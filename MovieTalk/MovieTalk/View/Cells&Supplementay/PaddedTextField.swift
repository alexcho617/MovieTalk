//
//  PaddedTextField.swift
//  MovieTalk
//
//  Created by Alex Cho on 11/27/23.
//

import UIKit

final class PaddedTextField: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: Design.paddingDefault,
        bottom: 0,
        right: Design.paddingDefault
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
