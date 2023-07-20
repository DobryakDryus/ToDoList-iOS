//
//  CellListView.swift
//  SwiftUIApp
//
//  Created by Andrey Oleynik on 18.07.2023.
//

import SwiftUI

struct CellListView: View {
    var toDoItem: ToDoItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(setImageString())
                .padding(.trailing, 10)
            if toDoItem.importance != .common && !toDoItem.completeStatus {
                Image(toDoItem.importance == .important ? "ImportantIcon" : "UnimportantIcon")
            }
            VStack(alignment: .leading, spacing: 0) {
                if !toDoItem.completeStatus {
                Text(toDoItem.text)
                    .lineLimit(3)
                } else {
                    Text(toDoItem.text)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .strikethrough()
                        .lineLimit(3)
                }
                if toDoItem.deadline != nil {
                    HStack (alignment: .center, spacing: 2) {
                        Image("CalendarIcon")
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                        Text(deadlineString())
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                    }
                }
            }
        }
    }
    
    private func setImageString() -> String {
        var imageString: String
        if toDoItem.completeStatus {
            imageString = "CompleteCircle"
        } else if toDoItem.importance == .important {
            imageString = "RedCircle"
        } else {
            imageString = "EmptyCircle"
        }
        return imageString
    }
    
    private func deadlineString() -> String {
        var deadlineString = ""
        if let deadline = toDoItem.deadline {
            deadlineString = DateFormatter.cellDateFormatter.string(from: deadline)
        }
        return deadlineString
    }
    
    init(item: ToDoItem) {
        self.toDoItem = item
    }
    
}

//struct CellListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellListView()
//    }
//}
