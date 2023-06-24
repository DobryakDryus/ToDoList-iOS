////
////  ItemViewController.swift
////  ToDoList
////
////  Created by Andrey Oleynik on 23.06.2023.
////
//
import UIKit

enum Color {
    
    case supportSeparator
    case supportOverlay
    case supportNavBar
    case labelPrimary
    case labelSecondary
    case labelTertiary
    case labelDisable
    case colorRed
    case colorGreen
    case colorBlue
    case colorGray
    case colorGrayLight
    case colorWhite
    case backiOSPrimary
    case backPrimary
    
    
    var uiColor: UIColor {
        switch self {
        case .supportSeparator:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        case .supportOverlay:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.06)
        case .supportNavBar:
            return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.8)
        case .labelPrimary:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        case .labelSecondary:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        case .labelTertiary:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        case .labelDisable:
            return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
        case .colorRed:
            return UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
        case .colorGreen:
            return UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
        case .colorBlue:
            return UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        case .colorGray:
            return UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0)
        case .colorGrayLight:
            return UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.0)
        case .colorWhite:
            return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .backiOSPrimary:
            return UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        case .backPrimary:
            return UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        }
    }

}

class ToDoTaskViewController: UIViewController, UITextViewDelegate {
    
    private var toDoList = FileCache(list: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        view.backgroundColor = Color.backPrimary.uiColor
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
        itemStackView.addArrangedSubview(secondSeparatorView)
        itemStackView.addArrangedSubview(calendarView)
        stackContentView.addArrangedSubview(deleteButton)
        setUpTaskViewConstraints()
        setUpLoadItemDetails()
    }
    
    private lazy var taskScrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        separatorView.backgroundColor = Color.supportSeparator.uiColor
        
        return separatorView
    }()
    
    private lazy var secondSeparatorView: UIView =  {
        let separatorView = UIView()
        separatorView.backgroundColor = Color.supportSeparator.uiColor
        separatorView.isHidden = true
        
        return separatorView
    }()
    
    private lazy var firstCellStackView: UIStackView = {
       let firstCellStackView = UIStackView()
        firstCellStackView.axis = .horizontal
        firstCellStackView.alignment = .center
       return firstCellStackView
    }()
    
    private lazy var importanceLabel: UILabel = {
        let importanceLabel = UILabel()
        importanceLabel.text = "Важность"
        importanceLabel.textColor = Color.labelPrimary.uiColor
        
        return importanceLabel
    }()
    
    private lazy var importanceControl: UISegmentedControl = {
        
        let downArrow = UIImage(systemName: "arrow.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(Color.labelSecondary.uiColor, renderingMode: .alwaysOriginal)
        
        let twoExclamation = UIImage(systemName: "exclamationmark.2", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!.withTintColor(Color.colorRed.uiColor, renderingMode: .alwaysOriginal)
        
        let importanceControl = UISegmentedControl(items: [downArrow, "нет", twoExclamation])
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
        deadlineLabel.textColor = Color.labelPrimary.uiColor
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
        
        
        
        calendarView.addTarget(self, action: #selector(changeDateTapped(_:)), for: .valueChanged)
        
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
        deleteButton.isEnabled = false
        deleteButton.setTitleColor(Color.labelTertiary.uiColor, for: .normal)

        return deleteButton
    }()

    @objc func myDeleteButtonTapped(_ sender: UIButton!) {
        guard let item = toDoList.listToDoItem.first else {
            print("Удалять нечего")
            return
        }
        toDoList.removeFromList(id: item.id)
        print("Успешно удален")
        toDoList.saveToFile()
    }
    
    private func setUpNavBar() {
        title = "Дело"

        let rightNavigationButton = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done ,  target: self, action: #selector(self.saveNavBarButtonTapped(_:)))
     
        let leftNavigationButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain ,  target: self, action: #selector(self.cancelNavBarButtonTapped(_:)))

        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.leftBarButtonItem = leftNavigationButton
        
        rightNavigationButton.isEnabled = false
    }
    
        private lazy var textViewItem: UITextView = {
            let textViewItem = UITextView()
            textViewItem.backgroundColor = Color.colorWhite.uiColor
            textViewItem.text = "Что надо сделать?"
            textViewItem.textColor = Color.labelTertiary.uiColor
            textViewItem.font = UIFont.systemFont(ofSize: 17)
            textViewItem.layer.cornerRadius = 12
            textViewItem.isScrollEnabled = false
            textViewItem.delegate = self
            textViewItem.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
            
            return textViewItem
        }()
    
        @objc func endEditing() {
            textViewItem.resignFirstResponder()
        }
    
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == Color.labelTertiary.uiColor {
                textView.text = nil
                textView.textColor = Color.labelPrimary.uiColor
            }
            textView.becomeFirstResponder()
        }
    
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Что надо сделать?"
                textView.textColor = Color.labelTertiary.uiColor
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                deleteButton.isEnabled = false
                deleteButton.setTitleColor(Color.labelTertiary.uiColor, for: .normal)
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                deleteButton.isEnabled = true
                deleteButton.setTitleColor(Color.colorRed.uiColor, for: .normal)
            }
            textView.resignFirstResponder()
        }
    
    @objc func saveNavBarButtonTapped(_ sender:UIBarButtonItem!)
        {
            let text = textViewItem.text ?? ""
            let completeStatus = false
            let deadlineDate = switchCase.isOn ? calendarView.date : nil
            var importance: Importance
            let createdAt = Date()
            
            switch importanceControl.selectedSegmentIndex {
            case 0: importance = Importance.unimportant
            case 1: importance = Importance.common
            case 2: importance = Importance.important
            default: importance = Importance.common
            }
            
            let item = ToDoItem.init(text: text,
                                     importance: importance,
                                     deadline: deadlineDate,
                                     completeStatus: completeStatus,
                                     createdAt: createdAt
                                     )
            toDoList.addItemToList(item: item)
            toDoList.saveToFile(withPath: "check.json")
        }
    
    func loadToDoItem() -> ToDoItem? {
        toDoList.loadFromFile(withPath: "ToDoList.json")
        guard let item = toDoList.listToDoItem.first else {return nil}
        
        return item
    }
    
    private func setUpLoadItemDetails() {
        guard let item = loadToDoItem() else { return }
        textViewItem.text = item.text
        switch item.importance {
        case .important: importanceControl.selectedSegmentIndex = 2
        case .unimportant: importanceControl.selectedSegmentIndex = 0
        default: importanceControl.selectedSegmentIndex = 1
        }
        if let deadline = item.deadline {
            switchCase.isOn = true
            let dateForm = DateFormatter()
            dateForm.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
            let deadlineStr = dateForm.string(from: deadline)
            deadlineDateButton.setTitle(deadlineStr, for: .normal)
        }
    }

    // returns to root view
    @objc func cancelNavBarButtonTapped(_ sender:UIBarButtonItem!)
        {
            self.dismiss(animated: true, completion: {
                if let navController = self.navigationController {
                    navController.popToRootViewController(animated: true)
                }
            })
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
            stackContentView.topAnchor.constraint(equalTo: taskScrollView.topAnchor, constant: 16),
            stackContentView.bottomAnchor.constraint(equalTo: taskScrollView.bottomAnchor),
            stackContentView.leftAnchor.constraint(equalTo: taskScrollView.leftAnchor),
            stackContentView.rightAnchor.constraint(equalTo: taskScrollView.rightAnchor)
        ])
    }
    
    private func setUpItemStackViewConstraints() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
            textViewItem.topAnchor.constraint(equalTo: stackContentView.topAnchor),
            textViewItem.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            textViewItem.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textViewItem.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }
}

