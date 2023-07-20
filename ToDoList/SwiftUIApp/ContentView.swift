//
//  ContentView.swift
//  SwiftUIApp
//
//  Created by Andrey Oleynik on 18.07.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isCompleteShown = false
    @StateObject private var fileCache: FileCache = FileCache(list: [ToDoItem(id: "1", text: "Пробежка", importance: .important, deadline: Date(), completeStatus: false, createdAt: Date(), changedAt: nil), ToDoItem(id: "4", text: "Eat watermelon and go to the shop", importance: .unimportant, deadline: nil, completeStatus: true, createdAt: Date(), changedAt: nil), ToDoItem(id: "17", text: "Letsgoo", importance: .common, deadline: nil, completeStatus: true, createdAt: Date(), changedAt: nil), ToDoItem(id: "120", text: "Never gonna give you up, never gonna let you down, never gonna run around and desert you, never gonna save goodbye", importance: .common, deadline: nil, completeStatus: false, createdAt: Date(), changedAt: nil)])
    
    private var completeCount: Int {
        self.fileCache.listToDoItem.filter { $0.completeStatus}.count
    }
    
    
    var body: some View {
        ZStack {
        NavigationView {
            ZStack {
        List {
            Section {
                ForEach(fileCache.listToDoItem) { item in
                    if !(!isCompleteShown && item.completeStatus) {
                    CellListView(item: item)
//                        .frame(minHeight: 42)
                        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 39))
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button{
                                setComplete(item: item)
                            } label: {
                                Image("SwipeLeadIcon")
                                    .font(.system(size: 40, weight: .regular))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .contentShape(Rectangle())
                                    
                            }.tint(.green)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(action: {
                                deleteItem(item)
                            }) {
                                Image("PinIcon")
                                
                            }.tint(.red)
                            Button(action: { print("lol") }) {
                                Image("InfoIcon")
                            }
                        }
                    }
                }
                
                .listRowSeparator(.visible, edges: .all)
    
            } header: {
                HStack {
                    Text("Выполнено — \(completeCount)")
                        .textCase(nil)
                        .font(.body)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                    Spacer()
                    Button(isCompleteShown ? "Скрыть" : "Показать") {
                        isCompleteShown.toggle()
                    }.textCase(nil).font(.bold(.body)())
                }
                .padding(.bottom, 4)
                
            } footer: {
                Button {} label : {
                Text("Новое")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .padding(.leading, 36)
                    .frame(height: 36)
                }
            }
        }.navigationTitle(Text("Мои дела"))
            }
        }
            VStack {
                Spacer()
                Button{} label : {
                    Image("PlusButton")
                        .padding()
                    }
            }
        }
    }
    
    private func setComplete(item: ToDoItem) {
        let changedItem = ToDoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, completeStatus: !item.completeStatus, createdAt: item.createdAt, changedAt: item.changedAt)
        fileCache.addItemToList(item: changedItem)
        
    }
    
    private func deleteItem(_ item: ToDoItem) {
        fileCache.removeFromList(id: item.id)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 11 Pro")
        }
    }
}
