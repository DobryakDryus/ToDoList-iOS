//
//  ViewController.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 20.06.2023.
//

import UIKit

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - table methods and variables
    
    private lazy var tableListView: UITableView = {
        let tableListView = UITableView()
        
        tableListView.tableHeaderView = tableHeaderView
        tableListView.backgroundColor = .purple
        
        tableListView.delegate = self
        tableListView.dataSource = self
        
        tableListView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        return tableListView
    }()
    
    private lazy var tableHeaderView: UIStackView = {
        let tableHeaderView = UIStackView(axis: .horizontal, distribution: .equalCentering, alignment: .fill, spacing: 0)
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.backgroundColor = .red

        NSLayoutConstraint.activate([
            tableHeaderView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return tableHeaderView
    }()
    
    private lazy var completeTasksCount: UILabel = {
        let completeTasksCount = UILabel()
        var count = 0
        completeTasksCount.text = "Выполнено - \(count)"
        completeTasksCount.textColor = UIColor.labelTertiary
        
        return completeTasksCount
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableListView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .cyan
        
        return cell
    }
    
    // MARK: - another func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backiOSPrimary
            
        setUpLayoutListView()
        //setUpAddItemButtonConstraints()
    }
    
    @objc func itemInfoButtonTapped() {
        let toDoTaskViewController = UINavigationController(rootViewController: ToDoTaskViewController())
        present(toDoTaskViewController, animated: true, completion: nil)
    }
    
    // MARK: - private methods and variables
    
//    private lazy var scrollListView: UIScrollView =  {
//
//    }()
    
    private lazy var itemInfoButton: UIButton = {
        let itemInfoButton = UIButton()
        itemInfoButton.setTitle("Добавить задачу", for: .normal)
        itemInfoButton.setTitleColor(.systemBlue, for: .normal)
        itemInfoButton.addTarget(self, action: #selector(itemInfoButtonTapped), for: .touchUpInside)

        return itemInfoButton
    }()
    
//    private func setUpAddItemButtonConstraints() {
//        itemInfoButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            itemInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            itemInfoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
    
    private func setUpNavBar() {
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = 32

    }

}

extension ToDoListViewController {
    
    private func setUpLayoutListView() {
        setUpNavBar()
//        view.addSubview(itemInfoButton)
        view.addSubview(tableListView)
        setUpTableViewConstraints()
    }
    
    private func setUpTableViewConstraints() {
        tableListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableListView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
        
    }
    
    
}
