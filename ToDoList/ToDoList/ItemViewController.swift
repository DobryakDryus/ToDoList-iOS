////
////  ItemViewController.swift
////  ToDoList
////
////  Created by Andrey Oleynik on 23.06.2023.
////
//
import UIKit

class ToDoTaskViewController: UIViewController, UITextViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setUpNavBar()
        view.addSubview(taskScrollView)
        taskScrollView.addSubview(stackContentView)
        stackContentView.addArrangedSubview(textViewItem)
        stackContentView.addArrangedSubview(itemStackView)
        itemStackView.addArrangedSubview(firstCellStackView)
        firstCellStackView.addArrangedSubview(importanceLabel)
        firstCellStackView.addArrangedSubview(importanceControl)
        itemStackView.addArrangedSubview(separatorView)
        itemStackView.addArrangedSubview(secondCellStackView)
        secondCellStackView.addArrangedSubview(stackWithDate)
        stackWithDate.addArrangedSubview(deadlineLabel)
        stackWithDate.addArrangedSubview(deadlineDateButton)
        stackWithDate.sendSubviewToBack(deadlineDateButton)
        secondCellStackView.addArrangedSubview(switchCase)
//        secondCellStackView.addArrangedSubview(<#T##view: UIView##UIView#>)
        itemStackView.addArrangedSubview(secondSeparatorView)
        itemStackView.addArrangedSubview(calendarView)
        stackContentView.addArrangedSubview(deleteButton)
        
        setUpTaskViewConstraints()
    }
    
    private lazy var taskScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemRed
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        return scrollView
    }()
    
    private lazy var stackContentView: UIStackView = {
        let stackContentView = UIStackView()
        stackContentView.axis = .vertical
        stackContentView.distribution = .fill
        stackContentView.alignment = .center
        stackContentView.spacing = 16
        
        return stackContentView
    }()
    
    private lazy var itemStackView: UIStackView = {
        let itemStackView = UIStackView()
        itemStackView.axis = .vertical
        itemStackView.distribution = .fill
        itemStackView.alignment = .center
        itemStackView.layer.cornerRadius = 16
        itemStackView.spacing = 0
        itemStackView.backgroundColor = .white
        
        return itemStackView
    }()
    
    private lazy var separatorView: UIView =  {
        let separatorView = UIView()
        separatorView.backgroundColor = .gray
        
        return separatorView
    }()
    
    private lazy var secondSeparatorView: UIView =  {
        let separatorView = UIView()
        separatorView.backgroundColor = .gray
        separatorView.isHidden = true
        return separatorView
    }()
    
    private lazy var firstCellStackView: UIStackView = {
       let firstCellStackView = UIStackView()
        firstCellStackView.axis = .horizontal
//        firstCellStackView.distribution = .fillEqually
        firstCellStackView.alignment = .center
       return firstCellStackView
    }()
    
    private lazy var importanceLabel: UILabel = {
        let importanceLabel = UILabel()
        importanceLabel.text = "Важность"
        importanceLabel.textColor = .black
        
        return importanceLabel
    }()
    
    private lazy var importanceControl: UISegmentedControl = {
        let importanceControl = UISegmentedControl(items: ["↓", "нет", "‼️"])
        importanceControl.selectedSegmentIndex = 1
        importanceControl.setWidth(49, forSegmentAt: 0)
        importanceControl.setWidth(49, forSegmentAt: 1)
        importanceControl.setWidth(49, forSegmentAt: 2)
        
        
        return importanceControl
    }()
    
    private lazy var secondCellStackView: UIStackView = {
       let secondCellStackView = UIStackView()
        secondCellStackView.axis = .horizontal
        secondCellStackView.distribution = .fill
        secondCellStackView.alignment = .center
       return secondCellStackView
    }()
    
    private lazy var stackWithDate: UIStackView = {
        let stackWithDate = UIStackView()
        stackWithDate.axis = .vertical
        stackWithDate.distribution = .fill
        stackWithDate.alignment = .leading
        stackWithDate.spacing = 2
        stackWithDate.translatesAutoresizingMaskIntoConstraints = false
        return stackWithDate
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let deadlineLabel = UILabel()
        deadlineLabel.text = "Сделать до"
        return deadlineLabel
    }()
    
    private lazy var deadlineDateButton: UIButton = {
        
        let deadlineDateButton = UIButton(type: .system)
        let dateForm = DateFormatter()
        dateForm.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        let nextDay = Date().addingTimeInterval(3600*24)
        let nextDayString = dateForm.string(from: nextDay)
        deadlineDateButton.setTitle(nextDayString, for: .normal)
        deadlineDateButton.setTitleColor(.systemBlue , for: .normal)
        deadlineDateButton.addTarget(self, action: #selector(interactWithCalendar), for: .touchUpInside)
        
        deadlineDateButton.isHidden = true
        
        return deadlineDateButton
    }()
    
    @objc func interactWithCalendar() {
        if calendarView.isHidden {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.secondSeparatorView.alpha = 1
                self.secondSeparatorView.isHidden = false
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations:{
                self.secondSeparatorView.alpha = 1
                self.calendarView.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.secondSeparatorView.alpha = 0
                self.secondSeparatorView.isHidden = true
            } completion: { _ in
                self.secondSeparatorView.alpha = 1
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.calendarView.alpha = 0
                self.calendarView.isHidden = true
            } completion: { _ in
                self.calendarView.alpha = 1
            }
        }
    }
    
    private lazy var switchCase: UISwitch = {
        let switchCase = UISwitch()
        switchCase.isOn = false
        switchCase.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        return switchCase
    }()
    
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
    
    private lazy var calendarView: UIDatePicker = {
        let calendarView = UIDatePicker()
        calendarView.datePickerMode = .date
        calendarView.date = Date().addingTimeInterval(3600*24)
        calendarView.preferredDatePickerStyle = .inline
        calendarView.minimumDate = Date()
        calendarView.isHidden = true
        
        
        
        calendarView.addTarget(self, action: #selector(changeDateTapped(_:)), for: .valueChanged )
        
        return calendarView
    }()
    
    @objc func changeDateTapped(_ sender: UIDatePicker!) {
        let newDate = sender.date
        let dateForm = DateFormatter()
        dateForm.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        let newDateString = dateForm.string(from: newDate)
        deadlineDateButton.setTitle(newDateString, for: .normal)
        interactWithCalendar()
    }
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 16
        deleteButton.addTarget(self, action: #selector(myDeleteButtonTapped(_:)), for: .touchUpInside)

        return deleteButton
    }()

    @objc func myDeleteButtonTapped(_ sender: UIButton!) {
        print("Ты потрясающий")
    }
    
    private func setUpNavBar() {
        title = "Дело"

        let rightNavigationButton = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain ,  target: self, action: #selector(self.myRightSideTaskNavigationBarButtonItemTapped(_:)))

        let leftNavigationButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain ,  target: self, action: #selector(self.myLeftSideTaskNavigationBarButtonItemTapped(_:)))

        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.leftBarButtonItem = leftNavigationButton
        
        rightNavigationButton.isEnabled = false
    }
    
    
        private lazy var textViewItem: UITextView = {
            let textViewItem = UITextView()
            textViewItem.backgroundColor = .white
            textViewItem.text = "Что надо сделать?"
            textViewItem.textColor = .lightGray
            textViewItem.layer.cornerRadius = 12
            textViewItem.isScrollEnabled = false
            textViewItem.delegate = self
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
            
            return textViewItem
        }()
    
        @objc func endEditing() {
            textViewItem.resignFirstResponder()
        }
    
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
            textView.becomeFirstResponder()
        }
    
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Что надо сделать?"
                textView.textColor = .lightGray
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                deleteButton.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                deleteButton.isEnabled = true
            }
            textView.resignFirstResponder()
        }
    
    @objc func myRightSideTaskNavigationBarButtonItemTapped(_ sender:UIBarButtonItem!)
        {
            print("Жмакнули правую")
        }

    @objc func myLeftSideTaskNavigationBarButtonItemTapped(_ sender:UIBarButtonItem!)
        {
            print("Жмакнули левую")
        }
}


extension ToDoTaskViewController {

    private func setUpTaskViewConstraints() {
        setUpTaskScrollViewConstraints()
        setUpStackContentViewConstraints()
        setUpTextViewItemConstraints()
        setUpItemStackViewConstraints()
        setUpStackFirstCellConstaints()
        setUpImportanceControlConstraints()
        setUpSeparatorCellConstraints()
        setUpStackSecondCellConstaints()
        setUpStackViewDateConstraints()
        setUpSecondSeparatorCellConstraints()
        setUpCalendarViewConstraints()
        setUpDeleteButtonConstraints()
    }

    private func setUpTaskScrollViewConstraints() {
        taskScrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            taskScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskScrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setUpStackContentViewConstraints() {
        stackContentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackContentView.topAnchor.constraint(equalTo: taskScrollView.topAnchor),
            stackContentView.bottomAnchor.constraint(equalTo: taskScrollView.bottomAnchor),
            stackContentView.leftAnchor.constraint(equalTo: taskScrollView.leftAnchor),
            stackContentView.rightAnchor.constraint(equalTo: taskScrollView.rightAnchor)
        ])
    }
    
    private func setUpItemStackViewConstraints() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            itemStackView.topAnchor.constraint(equalTo: textViewItem.bottomAnchor, constant: 16),
            itemStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            itemStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpStackFirstCellConstaints() {
        firstCellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstCellStackView.heightAnchor.constraint(equalToConstant: 56),
            firstCellStackView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 16),
            firstCellStackView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor, constant: -16)
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
            separatorView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 16),
            separatorView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpStackSecondCellConstaints() {
        secondCellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondCellStackView.heightAnchor.constraint(equalToConstant: 56),
            secondCellStackView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 16),
            secondCellStackView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor, constant: -16)
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
            secondSeparatorView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 16),
            secondSeparatorView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpCalendarViewConstraints() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor, constant: 16),
            calendarView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor, constant: -16),
        ])
    }
    
    
        private func setUpDeleteButtonConstraints() {
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                deleteButton.leftAnchor.constraint(equalTo: stackContentView.leftAnchor, constant: 16),
                deleteButton.rightAnchor.constraint(equalTo: stackContentView.rightAnchor,
                                                   constant: -16),
                deleteButton.heightAnchor.constraint(equalToConstant: 56),
                deleteButton.topAnchor.constraint(equalTo: itemStackView.bottomAnchor, constant: 16),
                deleteButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
            ])
        }
    
    
    private func setUpTextViewItemConstraints() {
        textViewItem.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textViewItem.topAnchor.constraint(equalTo: taskScrollView.topAnchor),
            textViewItem.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textViewItem.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textViewItem.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }
}

