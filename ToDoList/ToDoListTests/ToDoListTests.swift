//
//  ToDoListTests.swift
//  ToDoListTests
//
//

import XCTest
@testable import ToDoList

class ToDoListTests: XCTestCase {
    //        let jsonDict: [String: Any] = ["id": "421",
    //                                       "text": "Do something",
    //                                       "deadline": 21442124212.0,
    //                                       "importance": "unimportant",
    //                                       "completeStatus": true,
    //                                       "createdAt": 31500.0,
    //                                       "changedAt": 21445323.0 ]
    func testToDoItemInitWithAllParametrs() throws {
        let id = "421", text = "Do something"
        let date = Date(timeIntervalSince1970: 241242004202442.0)
        let deadline = Date(timeIntervalSince1970: 212321.0)
        let changeDate = Date(timeIntervalSince1970: 2123213123.0)

        
        let item = ToDoItem(id: "421", text: "Do something", importance: .unimportant, deadline: deadline, completeStatus: true, createdAt: date, changedAt: changeDate)
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.importance.rawValue, "unimportant")
        XCTAssertEqual(item.completeStatus, true)
        XCTAssertEqual(item.createdAt, date)
        XCTAssertEqual(item.changedAt, changeDate)
    }
    
    func testToDoItemInitWithoutID() throws {
        let text = "Do something"
        let date = Date(timeIntervalSince1970: 241242004202442.0)
        let deadline = Date(timeIntervalSince1970: 212321.0)
        let changeDate = Date(timeIntervalSince1970: 2123213123.0)

        
        let item = ToDoItem(text: "Do something", importance: .important, deadline: deadline, completeStatus: true, createdAt: date, changedAt: changeDate)
        XCTAssertNotNil(item.id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.importance.rawValue, "important")
        XCTAssertEqual(item.completeStatus, true)
        XCTAssertEqual(item.createdAt, date)
        XCTAssertEqual(item.changedAt, changeDate)
    }
    
    func testToDoItemInitWithNilDatesAndNoImportance() throws {
        let text = "Do something"
        let date = Date(timeIntervalSince1970: 241242004202442.0)
        
        let item = ToDoItem(text: "Do something", deadline: nil, completeStatus: false, createdAt: date)
        
        XCTAssertNotNil(item.id)
        XCTAssertEqual(item.text, text)
        XCTAssertNil(item.deadline)
        XCTAssertEqual(item.importance.rawValue, "common")
        XCTAssertEqual(item.completeStatus, false)
        XCTAssertEqual(item.createdAt, date)
        XCTAssertNil(item.changedAt)
    }
    
    func testToDoItemParseJSONWithAllParametrs() throws {
        let jsonDict: [String: Any] = ["id": "421",
                                       "text": "Do something",
                                       "deadline": 21442124212.0,
                                       "importance": "unimportant",
                                       "completeStatus": true,
                                       "createdAt": 31500.0,
                                       "changedAt": 21445323.0 ]
        let id = "421"
        let text = "Do something"
        let createdDate = Date(timeIntervalSince1970: 31500.0)
        let deadline = Date(timeIntervalSince1970: 21442124212.0)
        let changeDate = Date(timeIntervalSince1970: 21445323.0)
        let item = ToDoItem.parse(json: jsonDict)!
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.importance.rawValue, "unimportant")
        XCTAssertEqual(item.completeStatus, true)
        XCTAssertEqual(item.createdAt, createdDate)
        XCTAssertEqual(item.changedAt, changeDate)
    }
    
    func testToDoItemParseJSONWithoutImportanceAndChangedDate() throws {
        let jsonDict: [String: Any] = ["id": "421",
                                       "text": "Do something",
                                       "completeStatus": true,
                                       "createdAt": 31500.0]
        let id = "421"
        let text = "Do something"
        let createdDate = Date(timeIntervalSince1970: 31500.0)
        
        let item = ToDoItem.parse(json: jsonDict)!
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertNil(item.deadline)
        XCTAssertEqual(item.importance.rawValue, "common")
        XCTAssertEqual(item.completeStatus, true)
        XCTAssertEqual(item.createdAt, createdDate)
        XCTAssertNil(item.changedAt)
    }
    
    func testToDoItemParseJSONWithoutID() throws {
        let jsonDict: [String: Any] = [
                                       "text": "Do\"something",
                                       "deadline": 21442124212.0,
                                       "completeStatus": true,
                                       "createdAt": 31500.0]

        let item = ToDoItem.parse(json: jsonDict)
        
        XCTAssertNil(item)
    }
    
    func testToDoItemParseJSONWithoutCompleteStatusAndCreationDate() throws {
        let jsonDict: [String: Any] = ["id": "412421,21",
                                       "text": "Do\"something",
                                       "deadline": 21442124212.0
                                       ]
        let item = ToDoItem.parse(json: jsonDict)
        
        XCTAssertNil(item)
    }
    
    func testToDoItemParseJSONWithWrongCreatedType() throws {
        let jsonDict: [String: Any] = [ "id": "312",
                                       "text": "qwewq",
                                       "deadline": 21442124212.0,
                                       "completeStatus": true,
                                       "createdAt": "WRONG"]

        let item = ToDoItem.parse(json: jsonDict)
        
        XCTAssertNil(item)
    }
    
    func testToDoItemParseJSONWithNoValidInput() throws {
        let jsonDict = 15

        let item = ToDoItem.parse(json: jsonDict)
        
        XCTAssertNil(item)
    }
    
    func testToDoItemParseJSONWithNoValidInput2() throws {
        let jsonDict = "Correct JSON"

        let item = ToDoItem.parse(json: jsonDict)
        
        XCTAssertNil(item)
    }
    
    func testToDoItemComputedJSONWithAllOptions() throws {
        let jsonDict: [String: Any] = ["id": "421",
                                       "text": "Do something",
                                       "deadline": 21442124212.0,
                                       "importance": "unimportant",
                                       "completeStatus": true,
                                       "createdAt": 31500.0,
                                       "changedAt": 21445323.0 ]

        let item = ToDoItem.parse(json: jsonDict)!
        
        let jsonItem = item.json as! [String: Any]
        
        XCTAssertEqual(jsonItem["id"] as! String, jsonDict["id"] as! String)
        XCTAssertEqual(jsonItem["text"] as! String, jsonDict["text"] as! String)
        XCTAssertEqual(jsonItem["deadline"] as! Double, jsonDict["deadline"] as! Double)
        XCTAssertEqual(jsonItem["importance"] as! String, jsonDict["importance"] as! String)
        XCTAssertEqual(jsonItem["completeStatus"] as! Bool, jsonDict["completeStatus"] as! Bool)
        XCTAssertEqual(jsonItem["createdAt"] as! Double, jsonDict["createdAt"] as! Double)
        XCTAssertEqual(jsonItem["changedAt"] as! Double, jsonDict["changedAt"] as! Double)
        
    }
    
    func testToDoItemComputedJSONWithCommonImportanceAndNotValidDeadline() throws {
        let jsonDict: [String: Any] = ["id": "421",
                                       "text": "Do something",
                                       "deadline": "xd",
                                       "importance": "common",
                                       "completeStatus": true,
                                       "createdAt": 31500.0,
                                       "changedAt": 21445323.0 ]

        let item = ToDoItem.parse(json: jsonDict)!
        
        let jsonItem = item.json as! [String: Any]
        
        XCTAssertEqual(jsonItem["id"] as! String, jsonDict["id"] as! String)
        XCTAssertEqual(jsonItem["text"] as! String, jsonDict["text"] as! String)
        XCTAssertNil(jsonItem["deadline"])
        XCTAssertNil(jsonItem["importance"])
        XCTAssertEqual(jsonItem["completeStatus"] as! Bool, jsonDict["completeStatus"] as! Bool)
        XCTAssertEqual(jsonItem["createdAt"] as! Double, jsonDict["createdAt"] as! Double)
        XCTAssertEqual(jsonItem["changedAt"] as! Double, jsonDict["changedAt"] as! Double)
        
    }
    
    func testToDoItemParseCSVWithAllParametrs() throws {
        let csvString = "421;Do something;unimportant;21442124212.0;true;31500.0;21445323.0"
        let id = "421"
        let text = "Do something"
        let createdDate = Date(timeIntervalSince1970: 31500.0)
        let deadline = Date(timeIntervalSince1970: 21442124212.0)
        let changeDate = Date(timeIntervalSince1970: 21445323.0)
        let item = ToDoItem.parse(csv: csvString)!
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.importance.rawValue, "unimportant")
        XCTAssertEqual(item.completeStatus, true)
        XCTAssertEqual(item.createdAt, createdDate)
        XCTAssertEqual(item.changedAt, changeDate)
    }
    
    func testToDoItemParseCSVWithNoDeadlineAndChangedDate() throws {
        let csvString = "421;Do something;important; ;true;31500.0;"
        let id = "421"
        let text = "Do something"
        let createdDate = Date(timeIntervalSince1970: 31500.0)
        let item = ToDoItem.parse(csv: csvString)!
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertNil(item.deadline)
        XCTAssertEqual(item.importance.rawValue, "important")
        XCTAssertEqual(item.completeStatus, true)
        XCTAssertEqual(item.createdAt, createdDate)
        XCTAssertNil(item.changedAt)
    }
    
    func testToDoItemParseCSVWithInvalidCreationType() throws {
        let csvString = "421;Do something;important; ;true;zxc;"
 
        let item = ToDoItem.parse(csv: csvString)
        
        XCTAssertNil(item)
        
    }
    
    func testToDoItemParseCSVWithoutCreateDate() throws {
            let j: String = "1;Letsgoooo;important;;true;;2022.0"
            
            let item = ToDoItem.parse(csv: j)

            XCTAssertNil(item)
        }
    
    func testToDoItemParseCSVWithMoreFields() throws {
            let j: String = ";String;unimportant;;true;1234.0;21321;42;sadsa;421"
            let item: ToDoItem? = ToDoItem.parse(csv: j)
            XCTAssertNil(item)
        }
    
    func testToDoItemParseCSVWithNoID() throws {
            let j: String = ";String;unimportant;;true;1234.0;"
            let item: ToDoItem? = ToDoItem.parse(csv: j)
            XCTAssertNil(item)
        }

    func testToDoItemComputedCSVWithAllOptions() throws {
        let csvString = "421;Do something;common;21442124212.0;true;31500.0;21445323.0"
        let resultItem = "421;Do something;;21442124212.0;true;31500.0;21445323.0"
        let item = ToDoItem.parse(csv: csvString)!
        
        let csvItem = item.csv
        
        XCTAssertEqual(csvItem, resultItem)
        
    }
    
    func testToDoItemComputedCSVWithoutDates() throws {
        let csvString = "42321;Do\"something;important;nil;true;31500.0;nil"
        let resultItem = "42321;Do\"something;important;;true;31500.0;"
        let item = ToDoItem.parse(csv: csvString)!
        
        let csvItem = item.csv
        
        XCTAssertEqual(csvItem, resultItem)
        
    }
}
