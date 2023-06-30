//
//  ImportanceDeadlineStack.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 28.06.2023.
//

import UIKit

class ImportanceDeadlineStackView: UIStackView {
    
    // MARK: - internal variables
    
    lazy var importanceControl: UISegmentedControl = {
        
        let importanceControl = UISegmentedControl(items: [UIImage.downArrow, "нет", UIImage.twoExclamation])
        importanceControl.selectedSegmentIndex = 1
        importanceControl.setWidth(Static.importanceControlItemWidth, forSegmentAt: 0)
        importanceControl.setWidth(Static.importanceControlItemWidth, forSegmentAt: 1)
        importanceControl.setWidth(Static.importanceControlItemWidth, forSegmentAt: 2)
        
        return importanceControl
    }()
    
    lazy var calendarView: UIDatePicker = {
        let calendarView = UIDatePicker()
        calendarView.datePickerMode = .date
        calendarView.date = Date.nextDay()
        calendarView.preferredDatePickerStyle = .inline
        calendarView.minimumDate = Date()
        calendarView.isHidden = true
        
        calendarView.addTarget(self, action: #selector(changeDateTapped(_:)), for: .valueChanged)
        
        return calendarView
    }()
    
    lazy var deadlineDateButton: UIButton = {
        
        let deadlineDateButton = UIButton(type: .system)
        let nextDay = Date.nextDay()
        let nextDayString = DateFormatter.taskDateFormatter.string(from: nextDay)
        deadlineDateButton.setTitle(nextDayString, for: .normal)
        deadlineDateButton.setTitleColor(.systemBlue , for: .normal)
        deadlineDateButton.addTarget(self, action: #selector(interactWithCalendar), for: .touchUpInside)
        
        deadlineDateButton.isHidden = true
        
        return deadlineDateButton
    }()
    
    lazy var switchCase: UISwitch = {
        let switchCase = UISwitch()
        switchCase.isOn = false
        switchCase.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        return switchCase
    }()
    
    // MARK: - gesture recognizing functions
    
    @objc func interactWithCalendar() {
        if calendarView.isHidden {
            UIView.animate(withDuration: Static.animationDuration, delay: 0, options: .curveEaseIn, animations: {
                self.secondSeparatorView.alpha = 1
                self.secondSeparatorView.isHidden = false
            })
            UIView.animate(withDuration: Static.animationDuration, delay: 0, options: .curveEaseIn, animations:{
                self.secondSeparatorView.alpha = 1
                self.calendarView.isHidden = false
            })
        } else {
            UIView.animate(withDuration: Static.animationDuration, delay: 0, options: .curveEaseOut) {
                self.secondSeparatorView.alpha = 0
                self.secondSeparatorView.isHidden = true
            } completion: { _ in
                self.secondSeparatorView.alpha = 1
            }
            UIView.animate(withDuration: Static.animationDuration, delay: 0, options: .curveEaseOut) {
                self.calendarView.alpha = 0
                self.calendarView.isHidden = true
            } completion: { _ in
                self.calendarView.alpha = 1
            }
        }
    }
    
    @objc func switchToggled(_ sender: UISwitch! ) {
        if sender.isOn {
            deadlineDateButton.isHidden = false
        } else {
            deadlineDateButton.isHidden = true
            if !calendarView.isHidden {
                interactWithCalendar()
            }
        }
    }
    
    @objc func changeDateTapped(_ sender: UIDatePicker!) {
        let newDate = sender.date
        let dateForm = DateFormatter()
        dateForm.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        let newDateString = dateForm.string(from: newDate)
        deadlineDateButton.setTitle(newDateString, for: .normal)
        interactWithCalendar()
    }
    
    // MARK: - private methods and variables
    
    private enum Static {
        static let animationDuration = 0.3
        static let importanceControlItemWidth: CGFloat = 49
    }
    
    private lazy var separatorView: UIView =  {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.supportSeparator
        
        return separatorView
    }()
    
    private lazy var secondSeparatorView: UIView =  {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.supportSeparator
        separatorView.isHidden = true
        
        return separatorView
    }()
    
    private lazy var firstCellStackView: UIStackView = {
        let firstCellStackView = UIStackView(axis: .horizontal, distribution: .fill, alignment: .center, spacing: 0)

       return firstCellStackView
    }()
    
    private lazy var importanceLabel: UILabel = {
        let importanceLabel = UILabel()
        importanceLabel.text = "Важность"
        importanceLabel.textColor = UIColor.labelPrimary
        
        return importanceLabel
    }()
    
    private lazy var secondCellStackView: UIStackView = {
        let secondCellStackView = UIStackView(axis: .horizontal, distribution: .fill, alignment: .center, spacing: 0)
  
       return secondCellStackView
    }()
    
    private lazy var stackWithDate: UIStackView = {
        let stackWithDate = UIStackView(axis: .vertical, distribution: .fill, alignment: .leading, spacing: 2)
   
        return stackWithDate
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let deadlineLabel = UILabel()
        deadlineLabel.text = "Сделать до"
        deadlineLabel.textColor = UIColor.labelPrimary
        return deadlineLabel
    }()
    
    // MARK: - initializers

    init() {
        super.init(frame: CGRect())
        setLayoutImportanceDeadlineStackView()
        setUpConstraintsToStack()
    }
    
    convenience init(axis: NSLayoutConstraint.Axis,
                     stackDistribution: UIStackView.Distribution,
                     alignment: UIStackView.Alignment,
                     spacing: CGFloat) {
        self.init()
        self.axis = axis
        self.distribution = stackDistribution
        self.alignment = alignment
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - extension with constraints

extension ImportanceDeadlineStackView {
    
    private func setLayoutImportanceDeadlineStackView() {
        self.addArrangedSubview(firstCellStackView)
        firstCellStackView.addArrangedSubview(importanceLabel)
        firstCellStackView.addArrangedSubview(importanceControl)
        self.addArrangedSubview(separatorView)
        self.addArrangedSubview(secondCellStackView)
        secondCellStackView.addArrangedSubview(stackWithDate)
        stackWithDate.addArrangedSubview(deadlineLabel)
        stackWithDate.addArrangedSubview(deadlineDateButton)
        stackWithDate.sendSubviewToBack(deadlineDateButton)
        secondCellStackView.addArrangedSubview(switchCase)
        self.addArrangedSubview(secondSeparatorView)
        self.addArrangedSubview(calendarView)
    }
    
    private func setUpConstraintsToStack() {
        setUpStackFirstCellConstaints()
        setUpImportanceControlConstraints()
        setUpSeparatorCellConstraints()
        setUpStackSecondCellConstaints()
        setUpStackViewDateConstraints()
        setUpSecondSeparatorCellConstraints()
        setUpCalendarViewConstraints()
    }
    
    private func setUpStackFirstCellConstaints() {
        firstCellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstCellStackView.heightAnchor.constraint(equalToConstant: 56),
            firstCellStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            firstCellStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpImportanceControlConstraints() {
        importanceControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            importanceControl.topAnchor.constraint(equalTo: firstCellStackView.topAnchor, constant: 10),
            importanceControl.bottomAnchor.constraint(equalTo: firstCellStackView.bottomAnchor, constant: -10),
            importanceControl.rightAnchor.constraint(equalTo: firstCellStackView.rightAnchor)
        ])
    }
    
    private func setUpSeparatorCellConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            separatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpStackSecondCellConstaints() {
        secondCellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondCellStackView.heightAnchor.constraint(equalToConstant: 56),
            secondCellStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            secondCellStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpStackViewDateConstraints() {
        stackWithDate.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackWithDate.leftAnchor.constraint(equalTo: secondCellStackView.leftAnchor),
            stackWithDate.topAnchor.constraint(equalTo: secondCellStackView.topAnchor, constant: 8),
            stackWithDate.bottomAnchor.constraint(equalTo: secondCellStackView.bottomAnchor, constant: -8)
        ])
    }

    private func setUpSecondSeparatorCellConstraints() {
        secondSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            secondSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            secondSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpCalendarViewConstraints() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            calendarView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
        ])
    }
    
}
