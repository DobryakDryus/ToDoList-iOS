//
//  ViewController.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 20.06.2023.
//

import UIKit
import SQLite

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backiOSPrimary
            
        setUpLayoutListView()
        connectToDB()
        //loadFileCacheFromServer()
    }

    // MARK: - table methods and variables
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == 0 {
                let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                            byRoundingCorners: [.topLeft, .topRight],
                                            cornerRadii: CGSize(width: 16, height: 16))
                let shape = CAShapeLayer()
                shape.path = maskPath.cgPath
                cell.layer.mask = shape
            } else {
                let maskPath = UIBezierPath(roundedRect: cell.bounds,
                                            byRoundingCorners: [.topLeft, .topRight],
                                            cornerRadii: CGSize(width: 0, height: 0))
                let shape = CAShapeLayer()
                shape.path = maskPath.cgPath
                cell.layer.mask = shape
            }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowDone ? fileCache.listToDoItem.count : fileCache.listToDoItem.filter { $0.completeStatus == false}.count
    }

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cellTable = tableView.cellForRow(at: indexPath) as? ToDoListCell else {
            return nil
        }
        let makeDoneSwipeAction = UIContextualAction(style: .normal, title: nil, handler: {
             (_, _, completion) in
            let newItem = ToDoItem(id: cellTable.item.id, text: cellTable.item.text, importance: cellTable.item.importance, deadline: cellTable.item.deadline, completeStatus: !cellTable.item.completeStatus, createdAt: cellTable.item.createdAt, changedAt: cellTable.item.changedAt)
            self.fileCache.addItemToList(item: newItem)
            cellTable.setComplete()
            
            // CoreData PART
            self.coreData.updateInCoreData(item: newItem)
            
            //SQLite PART
//            self.fileCache.upsertItemInSQLite(dbConnection: self.dbConnection, item: newItem)
            
            //self.changeItemOnServer(with: newItem)
            self.updateCompleteLabel()
            tableView.reloadData()
            completion(true)
        })
        makeDoneSwipeAction.image = UIImage.checkmark
        makeDoneSwipeAction.backgroundColor = UIColor.colorGreen
        
        return UISwipeActionsConfiguration(actions: [makeDoneSwipeAction])
    }
    
    func updateCompleteLabel() {
        completeTasksCountLabel.text = "Выполнено  \u{2014} \(self.fileCache.listToDoItem.filter {$0.completeStatus == true}.count)"
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cellTable = tableListView.cellForRow(at: indexPath) as? ToDoListCell else{
            return nil
        }
        
        let checkInfoSwipeAction = UIContextualAction(style: .normal, title: nil, handler: {
             (_, _, completion) in
            let toDoItemTaskViewController = ToDoTaskViewController(item: self.fileCache.listToDoItem[indexPath.row])
            toDoItemTaskViewController.delegate = self
            let navTaskController = UINavigationController(rootViewController: toDoItemTaskViewController)
            self.present(navTaskController, animated: true, completion: nil)
            completion(true)
        })
        
        checkInfoSwipeAction.image = UIImage.info
        checkInfoSwipeAction.backgroundColor = UIColor.colorGray
        
        
        let makeDeleteSwipeAction = UIContextualAction(style: .normal, title: nil, handler: { (_, _, completion) in
            
            self.fileCache.removeFromList(id: cellTable.item.id)
            self.updateCompleteLabel()
            //self.deleteFromServer(with: cellTable.item.id)
            
            // CoreData PART
            self.coreData.deleteFromCoreData(itemID: cellTable.item.id)
            
            // SQLite PART
//            self.fileCache.deleteItemInSQLite(dbConnection: self.dbConnection, id: cellTable.item.id)
            
            tableView.reloadData()
            completion(true)
        })
        makeDeleteSwipeAction.image = UIImage.pin
        makeDeleteSwipeAction.backgroundColor = UIColor.colorRed
        
        return UISwipeActionsConfiguration(actions: [makeDeleteSwipeAction, checkInfoSwipeAction])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellTable = tableListView.dequeueReusableCell(withIdentifier: ToDoListCell.identifierCell, for: indexPath) as? ToDoListCell else {
            return UITableViewCell()
        }
        cellTable.backgroundColor = UIColor.colorWhite
        cellTable.accessoryType = .disclosureIndicator
        
        cellTable.item = isShowDone ? fileCache.listToDoItem[indexPath.row] :
        fileCache.listToDoItem.filter{ $0.completeStatus == false }[indexPath.row]
        
        cellTable.configure(with: cellTable.item)
        
        return cellTable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDoTaskViewController = ToDoTaskViewController(item: self.fileCache.listToDoItem[indexPath.row])
        toDoTaskViewController.delegate = self
        let toDoTaskNavViewConroller = UINavigationController(rootViewController: toDoTaskViewController)
        present(toDoTaskNavViewConroller, animated: true, completion: nil)
    }

    
    
    // MARK: - gestures recognizing functions
    
    @objc func showButtonTapped() {
        isShowDone = !isShowDone
        if isShowDone {
            showButton.setTitle("Скрыть", for: .normal)
        } else {
            showButton.setTitle("Показать", for: .normal)
        }
        
        tableListView.reloadData()
    }
    
    @objc func addItemButtonTapped() {
        let toDoTaskViewController = ToDoTaskViewController(item: nil)
        toDoTaskViewController.delegate = self
        let navTaskViewController = UINavigationController(rootViewController: toDoTaskViewController)
        self.present(navTaskViewController, animated: true, completion: nil)
    }
    
    // MARK: - private methods and variables
    
    private var dbConnection = try? Connection()
    
    private var coreData = FileCacheCoreData()
    
    private var fileCache = FileCache(list: [])
    
    private var isShowDone = true
    private var isDirty = false
    
    private func connectToDB() {
        
        // CoreDataPart
        fileCache.newList(list: coreData.loadFromCoreData())
    
        // SQLite PART
//        self.dbConnection = self.fileCache.createDataBaseSQL()
//        self.fileCache.loadListFromSQLiteDB(dbConnection: dbConnection)
        
        updateCompleteLabel()
        self.tableListView.reloadData()
    }
    
    private lazy var tableListView: UITableView = {
        let tableListView = UITableView()
        tableListView.backgroundColor = UIColor.backiOSPrimary
        tableListView.layer.cornerRadius = 12
        tableListView.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        tableListView.rowHeight = UITableView.automaticDimension
        tableListView.estimatedRowHeight = 56
        
        tableListView.tableHeaderView = tableHeaderView
        tableListView.tableFooterView = tableFooterView
        
        tableListView.delegate = self
        tableListView.dataSource = self
        
        tableListView.register(ToDoListCell.self, forCellReuseIdentifier: ToDoListCell.identifierCell)
        
        return tableListView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView(frame: CGRect (x: 0, y: 0, width: view.frame.width - 32, height: 40))
        
        return tableHeaderView
    }()
    
    private lazy var completeTasksCountLabel: UILabel = {
        let completeTasksCount = UILabel()
        var count = 0
        completeTasksCount.text = "Выполнено \u{2014} \(self.fileCache.listToDoItem.filter {$0.completeStatus == true}.count)"
        completeTasksCount.textColor = UIColor.labelTertiary
        completeTasksCount.font = UIFont.systemFont(ofSize: 15)
        
        return completeTasksCount
    }()
    
    private lazy var showButton: UIButton = {
        let showButton = UIButton(type: .system)
        showButton.setTitle("Скрыть", for: .normal)
        showButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        return showButton
    }()
    
    private lazy var tableFooterView: UIView = {
        let tableFooterView = UIView(frame: CGRect (x: 0, y: 0, width: view.frame.width - 32, height: 56))
        
        tableFooterView.backgroundColor = UIColor.colorWhite
        tableFooterView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner ]
        tableFooterView.layer.cornerRadius = 16
        let footerButton = UIButton()
        footerButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
     
        return tableFooterView
    }()
    
    private lazy var textFooter: UILabel = {
        let textFooter = UILabel()
        textFooter.text = "Новое"
        textFooter.textColor = UIColor.tertiaryLabel
        
        return textFooter
    }()
    
    private lazy var footerButton: UIButton = {
        let footerButton = UIButton()
        footerButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)

        return footerButton
    }()
    
    private lazy var addNewTaskButton: UIButton = {
        let addNewTaskButton = UIButton()
        addNewTaskButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        return addNewTaskButton
    }()
    
    private lazy var newTaskButtonImage: UIImageView = {
        let newTaskButtonImage = UIImageView()
        newTaskButtonImage.image = UIImage(named: "addButton")
        
        return newTaskButtonImage
    }()
    
    private func setUpNavBar() {
        navigationItem.title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = 32

    }
    
    // MARK: - syncronization with server
    
//    private func loadFileCacheFromServer() {
//        Task {
//            do {
//                let list = try await DefaultNetworkingService.getListFromServer()
//                fileCache.removeAll()
//                fileCache.newList(list: list)
//                DefaultNetworkingService.isDirty = false
//                updateCompleteLabel()
//                tableListView.reloadData()
//            } catch {
//                print("Ошибка \(error)")
//                DefaultNetworkingService.isDirty = true
//            }
//        }
//    }
//
//    private func addItemToServer(with item: ToDoItem) {
//        Task {
//            do {
//                let _ = try await DefaultNetworkingService.addElementToList(item: item)
//                DefaultNetworkingService.isDirty = false
//                updateCompleteLabel()
//                tableListView.reloadData()
//            } catch {
//                print("Ошибка \(error)")
//                DefaultNetworkingService.isDirty = true
//            }
//        }
//    }
//
//    private func changeItemOnServer(with item: ToDoItem) {
//        Task {
//            do {
//                let _ = try await DefaultNetworkingService.changeElementOnServer(item: item)
//                DefaultNetworkingService.isDirty = false
//                updateCompleteLabel()
//                tableListView.reloadData()
//            } catch {
//                print("Ошибка \(error)")
//                DefaultNetworkingService.isDirty = true
//            }
//        }
//    }
//
//    private func deleteFromServer(with id: String) {
//        Task {
//            do {
//                let _ = try await DefaultNetworkingService.deleteElementFromList(withId: id)
//                DefaultNetworkingService.isDirty = false
//                updateCompleteLabel()
//                tableListView.reloadData()
//            } catch {
//                print("Ошибка \(error)")
//                DefaultNetworkingService.isDirty = true
//            }
//        }
//    }

}

extension ToDoListViewController {
    
    // MARK: - constraints
    
    private func setUpLayoutListView() {
        setUpNavBar()
        view.addSubview(tableListView)
        tableHeaderView.addSubview(completeTasksCountLabel)
        tableHeaderView.addSubview(showButton)
        view.addSubview(addNewTaskButton)
        tableFooterView.addSubview(footerButton)
        tableFooterView.addSubview(textFooter)
        addNewTaskButton.addSubview(newTaskButtonImage)
        setUpTableViewConstraints()
        setUpHeaderTableConstraints()
        setUpFooterTableConstraints()
        setUpAddButtonConstraints()
    }
    
    private func setUpAddButtonConstraints() {
        addNewTaskButton.translatesAutoresizingMaskIntoConstraints = false
        newTaskButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addNewTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewTaskButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
            addNewTaskButton.widthAnchor.constraint(equalToConstant: 44),
            addNewTaskButton.heightAnchor.constraint(equalToConstant: 44),
            
            newTaskButtonImage.topAnchor.constraint(equalTo: addNewTaskButton.topAnchor),
            newTaskButtonImage.leftAnchor.constraint(equalTo: addNewTaskButton.leftAnchor),
            newTaskButtonImage.rightAnchor.constraint(equalTo: addNewTaskButton.rightAnchor),
            newTaskButtonImage.bottomAnchor.constraint(equalTo: addNewTaskButton.bottomAnchor)
            
        ])
    }
    
    private func setUpTableViewConstraints() {
        tableListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            tableListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableListView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableListView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpHeaderTableConstraints() {
        completeTasksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completeTasksCountLabel.leftAnchor.constraint(equalTo: tableHeaderView.leftAnchor, constant: 16),
            completeTasksCountLabel.topAnchor.constraint(equalTo: tableHeaderView.topAnchor, constant: 8),
            completeTasksCountLabel.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -12),
            
            showButton.topAnchor.constraint(equalTo: tableHeaderView.topAnchor, constant: 8),
            showButton.rightAnchor.constraint(equalTo: tableHeaderView.rightAnchor, constant: -16),
            showButton.bottomAnchor.constraint(equalTo: tableHeaderView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setUpFooterTableConstraints() {
        footerButton.translatesAutoresizingMaskIntoConstraints = false
        textFooter.translatesAutoresizingMaskIntoConstraints = false
    
        
        NSLayoutConstraint.activate([
            footerButton.leftAnchor.constraint(equalTo: tableFooterView.leftAnchor),
            footerButton.rightAnchor.constraint(equalTo: tableFooterView.rightAnchor),
            footerButton.topAnchor.constraint(equalTo: tableFooterView.topAnchor),
            footerButton.bottomAnchor.constraint(equalTo: tableFooterView.bottomAnchor),
            
            
            textFooter.leftAnchor.constraint(equalTo: tableFooterView.leftAnchor, constant: 52),
            textFooter.topAnchor.constraint(equalTo: tableFooterView.topAnchor, constant: 12),
            textFooter.bottomAnchor.constraint(equalTo: tableFooterView.bottomAnchor, constant: -12)
        ])
    }
}

extension ToDoListViewController: ToDoItemViewControllerDelegate {
    // MARK: - toDoItem delegate functions
    
    func didUpdateItem(_ item: ToDoItem) {
        let toChange = self.fileCache.isOldElement(item: item)
        self.fileCache.addItemToList(item: item)
        
        // CoreData PART
        if toChange {
            self.coreData.updateInCoreData(item: item)
        } else {
            self.coreData.insertInCoreData(item: item)
        }
        
        // Network Homework
//        if toChange {
//                    changeItemOnServer(with: item)
//        } else {
//                    addItemToServer(with: item)
//        }
        
        // SQLite PART
//        self.fileCache.upsertItemInSQLite(dbConnection: self.dbConnection, item: item)
        

        self.tableListView.reloadData()
    }
    
    func didDeleteItem(_ id: String) {
        self.fileCache.removeFromList(id: id)
        
        // CoreData PART
        self.coreData.deleteFromCoreData(itemID: id)
        //self.coreData.saveToCoreData(list: fileCache.listToDoItem)
        
        // SQLite PART
//        self.fileCache.deleteItemInSQLite(dbConnection: self.dbConnection, id: id)
        
        //deleteFromServer(with: id)
        updateCompleteLabel()
        self.tableListView.reloadData()
    }
}

