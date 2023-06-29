//
//  UIStackView+Extension.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 29.06.2023.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis,
                     distribution: UIStackView.Distribution,
                     alignment: UIStackView.Alignment,
                     spacing: CGFloat)  {
        self.init()
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
    
}
