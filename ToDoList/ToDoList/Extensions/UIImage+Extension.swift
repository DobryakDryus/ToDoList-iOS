//
//  UIImage+Extension.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 29.06.2023.
//

import UIKit

extension UIImage {
    static let downArrow = UIImage(systemName: "arrow.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(UIColor.labelSecondary, renderingMode: .alwaysOriginal)
    
    static let twoExclamation = UIImage(systemName: "exclamationmark.2", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(UIColor.colorRed, renderingMode: .alwaysOriginal)
}
