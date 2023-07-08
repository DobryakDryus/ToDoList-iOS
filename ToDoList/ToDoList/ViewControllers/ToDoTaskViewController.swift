//
//  ItemViewController.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 23.06.2023.
//
//
import UIKit


class ToDoTaskViewController: UIViewController, UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backPrimary
        
        setUpLayoutItemView()
        setUpTaskViewConstraints()
        setUpLoadItemDetails()
    }

    // MARK: - gesture recognizing functions
    
    @objc func endEditing() {
        textViewItem.resignFirstResponder() 
    }
    
    @objc func saveNavBarButtonTapped(_ sender:UIBarButtonItem!)
        {
            let text = textViewItem.text ?? ""
            let completeStatus = false
            let deadlineDate = importanceDeadlineStack.switchCase.isOn ? importanceDeadlineStack.calendarView.date : nil
            var importance: Importance
            let createdAt = Date()
            
            switch importanceDeadlineStack.importanceControl.selectedSegmentIndex {
            case 0: importance = Importance.unimportant
            case 1: importance = Importance.common
            case 2: importance = Importance.important
            default: importance = Importance.common
            }
            var id: String
            if let itemOld = item {
                id = itemOld.id
            } else {
                id = UUID().uuidString
            }
        
            let item = ToDoItem(
                id: id,
                text: text,
                importance: importance,
                deadline: deadlineDate,
                completeStatus: completeStatus,
                createdAt: createdAt
            )
            
            delegate?.didUpdateItem(item)
            
            dismiss(animated: true, completion: nil)
        }
    
    @objc func myDeleteButtonTapped(_ sender: UIButton!) {
        if let item = item {
            delegate?.didDeleteItem(item.id)
        }
        dismiss(animated: true)
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
    
    // MARK: - internal functions and variables
    
    var item: ToDoItem?
    weak var delegate: ToDoItemViewControllerDelegate?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.labelTertiary {
            textView.text = nil
            textView.textColor = UIColor.labelPrimary
        }
        textView.becomeFirstResponder()
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor.labelTertiary
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            deleteButton.isEnabled = false
            deleteButton.setTitleColor(UIColor.labelTertiary, for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            deleteButton.isEnabled = true
            deleteButton.setTitleColor(UIColor.colorRed, for: .normal)
        }
        textView.resignFirstResponder()
    }
    
    // MARK: - private methods and variables
    
    private var filepath = "ToDoList.json"
    
    private enum Static {
        static let cornerRadius: CGFloat = 16
        static let textViewCornerRadius: CGFloat = 12
        static let textSizeInset: CGFloat = 16
    }
    
    private func setUpNavBar() {
        title = "Дело"

        let rightNavigationButton = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done ,  target: self, action: #selector(self.saveNavBarButtonTapped(_:)))
     
        let leftNavigationButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain ,  target: self, action: #selector(self.cancelNavBarButtonTapped(_:)))

        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.leftBarButtonItem = leftNavigationButton
        
        rightNavigationButton.isEnabled = false
    }
    
    private lazy var taskScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        return scrollView
    }()
    
    private lazy var stackContentView: UIStackView = {
        let stackContentView = UIStackView(axis: .vertical, distribution: .fill, alignment: .center, spacing: 16)
        
        return stackContentView
    }()
    
    private lazy var textViewItem: UITextView = {
        let textViewItem = UITextView()
        textViewItem.backgroundColor = UIColor.colorWhite
        textViewItem.text = "Что надо сделать?"
        textViewItem.textColor = UIColor.labelTertiary
        textViewItem.font = UIFont.systemFont(ofSize: 17)
        textViewItem.layer.cornerRadius = Static.textViewCornerRadius
        textViewItem.isScrollEnabled = false
        textViewItem.delegate = self
        textViewItem.textContainerInset = UIEdgeInsets(top: Static.textSizeInset, left: Static.textSizeInset, bottom: Static.textSizeInset, right: Static.textSizeInset)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        return textViewItem
    }()
    
    private lazy var importanceDeadlineStack: ImportanceDeadlineStackView = {
        let importanceDeadlineStack = ImportanceDeadlineStackView(axis: .vertical, stackDistribution: .fill, alignment: .center, spacing: 0)

        importanceDeadlineStack.layer.cornerRadius = Static.cornerRadius
        importanceDeadlineStack.backgroundColor = UIColor.colorWhite
        
        return importanceDeadlineStack
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.backgroundColor = UIColor.colorWhite
        deleteButton.layer.cornerRadius = Static.cornerRadius
        deleteButton.addTarget(self, action: #selector(myDeleteButtonTapped(_:)), for: .touchUpInside)
        deleteButton.isEnabled = false
        deleteButton.setTitleColor(UIColor.labelTertiary, for: .normal)

        return deleteButton
    }()
    
    private func setUpLoadItemDetails() {
        guard let item = item else { return }
        textViewItem.text = item.text
        textViewItem.textColor = UIColor.labelPrimary
        switch item.importance {
        case .important: importanceDeadlineStack.importanceControl.selectedSegmentIndex = 2
        case .unimportant: importanceDeadlineStack.importanceControl.selectedSegmentIndex = 0
        default:
            importanceDeadlineStack.importanceControl.selectedSegmentIndex = 1
        }
        if let deadline = item.deadline {
            importanceDeadlineStack.switchCase.isOn = true

            let deadlineStr = DateFormatter.taskDateFormatter.string(from: deadline)
            importanceDeadlineStack.deadlineDateButton.setTitle(deadlineStr, for: .normal)
            importanceDeadlineStack.deadlineDateButton.isHidden = false
        }
        deleteButton.isEnabled = true
        deleteButton.setTitleColor(UIColor.colorRed, for: .normal)
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    init(item: ToDoItem?) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - extension with constraints

extension ToDoTaskViewController {
    
    private func setUpLayoutItemView() {
        setUpNavBar()
        view.addSubview(taskScrollView)
        taskScrollView.addSubview(stackContentView)
        stackContentView.addArrangedSubview(textViewItem)
        stackContentView.addArrangedSubview(importanceDeadlineStack)
        stackContentView.addArrangedSubview(deleteButton)
    }

    private func setUpTaskViewConstraints() {
        setUpTaskScrollViewConstraints()
        setUpStackContentViewConstraints()
        setUpTextViewItemConstraints()
        setUpimportanceDeadlineStackConstraints()
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
    
    private func setUpimportanceDeadlineStackConstraints() {
        importanceDeadlineStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            importanceDeadlineStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            importanceDeadlineStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
 
    private func setUpDeleteButtonConstraints() {
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                deleteButton.leftAnchor.constraint(equalTo: stackContentView.leftAnchor, constant: 16),
                deleteButton.rightAnchor.constraint(equalTo: stackContentView.rightAnchor,
                                                   constant: -16),
                deleteButton.heightAnchor.constraint(equalToConstant: 56),
                deleteButton.topAnchor.constraint(equalTo: importanceDeadlineStack.bottomAnchor, constant: 16),
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

protocol ToDoItemViewControllerDelegate: AnyObject {
    func didUpdateItem(_ item: ToDoItem)
    func didDeleteItem(_ id: String)
}

