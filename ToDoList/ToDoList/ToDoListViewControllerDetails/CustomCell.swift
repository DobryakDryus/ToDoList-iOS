//
//  CustomCell.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 01.07.2023.
//

import UIKit

class ToDoListCell: UITableViewCell {
    
    // MARK: - internal variables and methods
    
    static let identifierCell = "ToDoListCell"
    var item: ToDoItem!
    
    func configure(with item: ToDoItem) {
        self.item = item
        setImage()
        setTextToCell()
        if let deadline = item.deadline {
            stackDeadline.isHidden = false
            calendarImageView.image = UIImage.calendar
            deadlineTextLabel.text = DateFormatter.cellDateFormatter.string(from: deadline)
        }
    }
    
    func setComplete() {
        labelStackView.attributedText = NSAttributedString(string: self.item.text , attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        imageCell.image = UIImage(named: "completeCircle")
    }
    
    // MARK: - private variables and methods
    
    private let cellContentView: UIView = {
        let cellContentView = UIView()
        
        return cellContentView
    }()
    
    private var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.circle
        imageView.contentMode = .scaleAspectFit
        
        
        return imageView
    }()
    
    private  var textStackView: UIStackView = {
        let textStackView = UIStackView(axis: .vertical, distribution: .equalCentering, alignment: .leading, spacing: 0)
        
        return textStackView
    }()
    
    private  var labelStackView: UILabel = {
        let labelStackView = UILabel()
        labelStackView.numberOfLines = 3
        labelStackView.font = .systemFont(ofSize: 17)
        
        return labelStackView
    }()
    
    private var stackDeadline: UIStackView = {
        let stackDeadline = UIStackView(axis: .horizontal, distribution: .fillProportionally, alignment: .leading, spacing: 2)
            stackDeadline.isHidden = true
        
        return stackDeadline
    }()
    
    private let calendarImageView: UIImageView = {
        let calendarImageView = UIImageView()
        calendarImageView.image = UIImage.calendar
        
        return calendarImageView
    }()
    
    private var deadlineTextLabel: UILabel = {
        let deadlineTextLabel = UILabel()
        deadlineTextLabel.font = .systemFont(ofSize: 15)
        deadlineTextLabel.textColor = UIColor.labelTertiary
        
        return deadlineTextLabel
    }()
    
    private func setImage() {
        if self.item.completeStatus {
            imageCell.image = UIImage(named: "completeCircle")
        } else if self.item.importance == .important {
            imageCell.image = UIImage(named: "redCircle")
        } else {
            imageCell.image = UIImage(named: "emptyCircle")
        }
    }
    
    private func setTextToCell() {
        if item.completeStatus {
            labelStackView.attributedText = NSAttributedString(string: item.text , attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            labelStackView.textColor = UIColor.labelTertiary
        } else {
            var cellText = ""
                switch item.importance {
                case .important: cellText = "‼️" + item.text
                case .unimportant: cellText = "↓" + item.text
                default: cellText = item.text
            }
            labelStackView.text = cellText
            labelStackView.textColor = UIColor.labelPrimary
        }
    }
    
    
    // MARK: - initializers and overriden func
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.image = nil
        labelStackView.attributedText = nil
        labelStackView.text = nil
        deadlineTextLabel.text = nil
        calendarImageView.image = nil
        accessoryType = .none
        isUserInteractionEnabled = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setUpLayoutToDoListCell()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ToDoListCell {
    
    // MARK: - costraints
    
    private func setUpLayoutToDoListCell() {
        self.addSubview(cellContentView)
        cellContentView.addSubview(imageCell)
        cellContentView.addSubview(textStackView)
        textStackView.addArrangedSubview(labelStackView)
        textStackView.addArrangedSubview(stackDeadline)
        textStackView.sendSubviewToBack(stackDeadline)
        stackDeadline.addArrangedSubview(calendarImageView)
        stackDeadline.addArrangedSubview(deadlineTextLabel)
    }
    
    private func setUpConstraints() {
        setUpContentViewConstraints()
        setUpImageViewConstraints()
        setUpTextStackView()
    }
    
    private func setUpContentViewConstraints() {
    
    cellContentView.translatesAutoresizingMaskIntoConstraints = false
        
    NSLayoutConstraint.activate([
        cellContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
        cellContentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
        cellContentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -39),
        cellContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
    ])
    }
    
    private func setUpImageViewConstraints() {
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCell.centerYAnchor.constraint(equalTo: cellContentView.centerYAnchor),
            imageCell.leftAnchor.constraint(equalTo: cellContentView.leftAnchor),
            imageCell.widthAnchor.constraint(equalToConstant: 24),
            imageCell.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setUpTextStackView() {
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textStackView.leftAnchor.constraint(equalTo: imageCell.rightAnchor, constant: 12),
            textStackView.topAnchor.constraint(equalTo: cellContentView.topAnchor),
            textStackView.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor),
            textStackView.rightAnchor.constraint(equalTo: cellContentView.rightAnchor)
        ])
    }
}
