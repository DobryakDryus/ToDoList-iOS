//
//  ViewController.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 20.06.2023.
//

import UIKit

class ToDoTaskViewController: UIViewController, UITextViewDelegate {
    
    
    
    private lazy var taskScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemCyan
        scrollView.layer.cornerRadius = 12
        
//        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 50)
        
//        let maskPath = UIBezierPath(roundedRect: scrollView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = scrollView.bounds
//        maskLayer.path = maskPath.cgPath
//        scrollView.layer.mask = maskLayer
//        scrollView.layer.masksToBounds = true
        
        
        return scrollView
    }()
    
    private lazy var navigationTaskBar: UINavigationBar = {
        let navigationTaskBar = UINavigationBar()

        let navigationItem = UINavigationItem(title: "Дело")
        
        let rightNavigationButton = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.plain ,  target: self, action: #selector(self.myRightSideTaskNavigationBarButtonItemTapped(_:)))
        
        let leftNavigationButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain ,  target: self, action: #selector(self.myLeftSideTaskNavigationBarButtonItemTapped(_:)))

        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.leftBarButtonItem = leftNavigationButton
        navigationTaskBar.setItems([navigationItem], animated: false)
        return navigationTaskBar
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.addTarget(self, action: #selector(myDeleteButtonTapped(_:)), for: .touchUpInside)
        
        return deleteButton
    }()
    
    @objc func myDeleteButtonTapped(_ sender: UIButton!) {
        print("Ты потрясающий")
    }
    
    @objc func myRightSideTaskNavigationBarButtonItemTapped(_ sender:UIBarButtonItem!)
        {
            print("Жмакнули правую")
        }

    @objc func myLeftSideTaskNavigationBarButtonItemTapped(_ sender:UIBarButtonItem!)
        {
            print("Жмакнули левую")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        view.addSubview(navigationTaskBar)
        view.addSubview(taskScrollView)
        taskScrollView.addSubview(textViewItem)
        taskScrollView.addSubview(deleteButton)
        
        setUpTaskViewConstraints()
    }

}


extension ToDoTaskViewController {
    
    private func setUpTaskViewConstraints() {
        setUpTaskScrollViewConstraints()
        setUpTaskNavigationBarConstraints()
        setUpTextViewItemConstraints()
        setUpDeleteButtonConstraints()
    }
    
    private func setUpTaskScrollViewConstraints() {
        taskScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskScrollView.topAnchor.constraint(equalTo: navigationTaskBar.bottomAnchor),
            taskScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            taskScrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setUpTaskNavigationBarConstraints() {
        navigationTaskBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            navigationTaskBar.heightAnchor.constraint(equalToConstant: 56),
            navigationTaskBar.widthAnchor.constraint(equalToConstant:  view.frame.size.width),
            navigationTaskBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            navigationTaskBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationTaskBar.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setUpTextViewItemConstraints() {
        textViewItem.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textViewItem.topAnchor.constraint(equalTo: taskScrollView.topAnchor),
            textViewItem.leftAnchor.constraint(equalTo: taskScrollView.leftAnchor, constant: 16),
            textViewItem.rightAnchor.constraint(equalTo: taskScrollView.rightAnchor, constant: -16),
            textViewItem.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }
    
    private func setUpDeleteButtonConstraints() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.leftAnchor.constraint(equalTo: taskScrollView.leftAnchor, constant: 16),
            deleteButton.rightAnchor.constraint(equalTo: taskScrollView.rightAnchor,
                                               constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.bottomAnchor.constraint(equalTo: taskScrollView.bottomAnchor, constant: -60),
            deleteButton.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
            deleteButton.topAnchor.constraint(equalTo: textViewItem.bottomAnchor)
        ])
    }
    
}




//    private var labelView: UILabel = {
//
//        let labelView = UILabel()
//        labelView.text = "SIIIIU"
//        labelView.textColor = .red
//        labelView.font = UIFont.boldSystemFont(ofSize: 24)
//
//        return labelView
//    }()
//
//    private var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .darkGray
//
//
//        return scrollView
//    }()
//
//    private var tableView: UITableView = {
//        let tableView = UITableView()
//
//
//        return tableView
//    }()
//
//    private var addItemButton: UIButton = {
//        let addItemButton = UIButton()
//
//        addItemButton.setTitle("+", for: .normal)
//        addItemButton.setTitleColor(.cyan , for: .normal)
//        addItemButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 60)
//        addItemButton.backgroundColor = .red
//        addItemButton.layer.cornerRadius = 15
//
//        return addItemButton
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .cyan
//
//        [labelView, scrollView, addItemButton].forEach {
//            view.addSubview($0)
//        }
//
//        setUpConstraintsToViews()
//        // Do any additional setup after loading the view.
//    }
//
//
//    private func setUpConstraintsToViews() {
//        setUpLabelConstraints()
//        setUpScrollConstraints()
//        setUpAddItemButtonConstraints()
//    }
//
//    private func setUpScrollConstraints() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
////            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            scrollView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 10),
//            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
//        ])
//    }
//
//    private func setUpLabelConstraints() {
//        labelView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            labelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            labelView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30)
//        ])
//    }
//
//    private func setUpAddItemButtonConstraints() {
//        addItemButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addItemButton.widthAnchor.constraint(equalToConstant: 60),
//            addItemButton.heightAnchor.constraint(equalToConstant: 60),
//            addItemButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
//        ])
//    }
//
