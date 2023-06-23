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
        itemStackView.addArrangedSubview(separatorView)
        itemStackView.addArrangedSubview(secondCellStackView)
        itemStackView.addArrangedSubview(secondSeparatorView)
        itemStackView.addArrangedSubview(calendarView)
        stackContentView.addArrangedSubview(deleteButton)
//        stackContentView.addArrangedSubview(deleteButton)

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
        
        return separatorView
    }()
    
    private lazy var firstCellStackView: UIStackView = {
       let firstCellStackView = UIStackView()
        firstCellStackView.axis = .horizontal
        firstCellStackView.distribution = .fill
        firstCellStackView.alignment = .center
       return firstCellStackView
    }()
    
    private lazy var importanceLabel: UILabel = {
        let importanceLabel = UILabel()
        importanceLabel.text = "Важность"
        importanceLabel.textColor = .black
        
        return importanceLabel
    }()
    
    private lazy var secondCellStackView: UIStackView = {
       let secondCellStackView = UIStackView()
//       secondCellStackView.isHidden = true
       return secondCellStackView
    }()
    
    private lazy var calendarView: UIDatePicker = {
        let calendarView = UIDatePicker()
        calendarView.datePickerMode = .date
        calendarView.date = Date().addingTimeInterval(3600*24)
        calendarView.preferredDatePickerStyle = .inline
        calendarView.minimumDate = Date()
        calendarView.isHidden = false
        return calendarView
    }()
    
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
            
//            let tapEndEditing = UITapGestureRecognizer(target: self, action: #selector(endEditing))
//            self.view.addGestureRecognizer(tapEndEditing)
//
            return textViewItem
        }()
    
//        @objc func endEditing() {
//            textViewItem.resignFirstResponder()
//        }
    
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
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
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
        setUpSeparatorCellConstraints()
        setUpStackSecondCellConstaints()
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
            itemStackView.topAnchor.constraint(equalTo: textViewItem.bottomAnchor, constant: 16),
            itemStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            itemStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    private func setUpStackFirstCellConstaints() {
        firstCellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstCellStackView.heightAnchor.constraint(equalToConstant: 56),
            firstCellStackView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor),
            firstCellStackView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor)
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
            secondCellStackView.leftAnchor.constraint(equalTo: itemStackView.leftAnchor),
            secondCellStackView.rightAnchor.constraint(equalTo: itemStackView.rightAnchor)
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
//            calendarView.heightAnchor.constraint(equalToConstant: 332)
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
//                deleteButton.bottomAnchor.constraint(equalTo: textViewItem.bottomAnchor)
            ])
        }
    
//    private func setUpContentViewConstraints() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: view.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            contentView.leftAnchor.constraint(equalTo: view.leftAnchor)
//        ])
//    }
    
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
//

//
//
//    private lazy var deleteButton: UIButton = {
//        let deleteButton = UIButton(type: .system)
//        deleteButton.setTitle("Удалить", for: .normal)
//        deleteButton.setTitleColor(.systemRed, for: .normal)
//        deleteButton.backgroundColor = .white
//        deleteButton.addTarget(self, action: #selector(myDeleteButtonTapped(_:)), for: .touchUpInside)
//
//        return deleteButton
//    }()
//
//    @objc func myDeleteButtonTapped(_ sender: UIButton!) {
//        print("Ты потрясающий")
//    }
//
//    @objc func myRightSideTaskNavigationBarButtonItemTapped(_ sender:UIBarButtonItem!)
//        {
//            print("Жмакнули правую")
//        }
//
//    @objc func myLeftSideTaskNavigationBarButtonItemTapped(_ sender:UIBarButtonItem!)
//        {
//            print("Жмакнули левую")
//        }
//
//    private lazy var textViewItem: UITextView = {
//        let textViewItem = UITextView()
//        textViewItem.backgroundColor = .white
//        textViewItem.text = "Что надо сделать?"
//        textViewItem.textColor = .lightGray
//        textViewItem.layer.cornerRadius = 12
//        textViewItem.isScrollEnabled = false
//        textViewItem.delegate = self
//        return textViewItem
//    }()
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .lightGray {
//            textView.text = nil
//            textView.textColor = .black
//        }
//    }
//
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Что надо сделать?"
//            textView.textColor = .lightGray
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemPurple
//
//        view.addSubview(navigationTaskBar)
//        view.addSubview(taskScrollView)
//        taskScrollView.addSubview(textViewItem)
//        taskScrollView.addSubview(deleteButton)
//
//        setUpTaskViewConstraints()
//    }
//
//}
//
//
//extension ToDoTaskViewController {
//
//    private func setUpTaskViewConstraints() {
//        setUpTaskScrollViewConstraints()
////        setUpTaskNavigationBarConstraints()
//        setUpTextViewItemConstraints()
//        setUpDeleteButtonConstraints()
//    }
//
//    private func setUpTaskScrollViewConstraints() {
//        taskScrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            taskScrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            taskScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            taskScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            taskScrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
//        ])
//    }
//
////    private func setUpTaskNavigationBarConstraints() {
////        navigationTaskBar.translatesAutoresizingMaskIntoConstraints = false
////
////        NSLayoutConstraint.activate([
////            navigationTaskBar.heightAnchor.constraint(equalToConstant: 56),
////            navigationTaskBar.widthAnchor.constraint(equalToConstant:  view.frame.size.width),
////            navigationTaskBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
////            navigationTaskBar.leftAnchor.constraint(equalTo: view.leftAnchor),
////            navigationTaskBar.rightAnchor.constraint(equalTo: view.rightAnchor)
////        ])
////    }
//
//    private func setUpTextViewItemConstraints() {
//        textViewItem.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            textViewItem.topAnchor.constraint(equalTo: taskScrollView.topAnchor),
//            textViewItem.leftAnchor.constraint(equalTo: taskScrollView.leftAnchor, constant: 16),
//            textViewItem.rightAnchor.constraint(equalTo: taskScrollView.rightAnchor, constant: -16),
//            textViewItem.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
//        ])
//    }
//
//    private func setUpDeleteButtonConstraints() {
//        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            deleteButton.leftAnchor.constraint(equalTo: taskScrollView.leftAnchor, constant: 16),
//            deleteButton.rightAnchor.constraint(equalTo: taskScrollView.rightAnchor,
//                                               constant: -16),
//            deleteButton.heightAnchor.constraint(equalToConstant: 56),
//            deleteButton.bottomAnchor.constraint(equalTo: taskScrollView.bottomAnchor, constant: -60),
//            deleteButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
//            deleteButton.topAnchor.constraint(equalTo: textViewItem.bottomAnchor)
//        ])
//    }
//
//}
