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
    
    static let calendar = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(UIColor.labelTertiary, renderingMode: .alwaysOriginal)
    
    static let circle = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(weight: .regular ))!.withTintColor(UIColor.colorRed, renderingMode: .alwaysOriginal)
    
    static let checkmark = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(UIColor.colorWhite, renderingMode: .alwaysOriginal)
    
    static let info = UIImage(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(UIColor.colorWhite, renderingMode: .alwaysOriginal)
    
    static let pin = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(UIColor.colorWhite, renderingMode: .alwaysOriginal)
    
}
