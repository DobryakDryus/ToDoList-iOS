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
        taskScrollView.addSubview(textViewItem)
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
    
//    private lazy var contentView: UIView = {
//        let contentView = UIView()
//
//        return contentView
//    }()

    
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
            return textViewItem
        }()
    
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
        }
    
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Что надо сделать?"
                textView.textColor = .lightGray
            }
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
        setUpTextViewItemConstraints()
//        setUpDeleteButtonConstraints()
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
