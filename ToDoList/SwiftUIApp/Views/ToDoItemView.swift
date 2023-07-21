//
//  ToDoItemView.swift
//  SwiftUIApp
//
//  Created by Andrey Oleynik on 20.07.2023.
//

import SwiftUI

struct ToDoItemView: View {
    @State var text = ""
    @State var isOn = false
    @State var selectedImportance = 1
    @State var deadlineDate = Date.nextDay()
    @State var isCalendarVisible = false
    var countLines: Int {
        return text.filter{$0 == "\n"}.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.backPrimary).ignoresSafeArea(.all)
                ScrollView {
            VStack(alignment: .center, spacing: 16) {
                
                TextEditor(text: $text)
                    .frame(minHeight: countLines <= 3 ? 120 : CGFloat((countLines+1)) * 25 + 1)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                    .cornerRadius(12)
                    .background(Color.white.cornerRadius(12))
                    .foregroundColor(Color.black)
                    .lineLimit(nil)
                    .overlay(
                        Group {
                        if text.isEmpty {
                        HStack(alignment: .top) {
                            Text("Что надо сделать?")
                                .foregroundColor(Color(UIColor.labelTertiary))
                            Spacer()
                        }
                        } }.padding(EdgeInsets(top: -47, leading: 20, bottom: 0, trailing: 16))
                            .frame(maxHeight: 30)
                           )

                
                    
                    
                
                VStack {
                    HStack (alignment: .center) {
                        Text("Важность")
                        Spacer()
                        Picker("", selection: $selectedImportance) {
                            Image("UnimportantIcon").tag(0)
                            Text("нет").tag(1)
                            Image("ImportantIcon").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 150)
                        
                    }.frame(height: 56).padding(.horizontal, 16)

                    setDivider()
                    HStack (alignment: .center) {
                        VStack (alignment: .leading, spacing: 2) {
                            Text("Сделать до")
                            if isOn {
                                Button {
                                    withAnimation {isCalendarVisible.toggle() } } label: {
                                Text(DateFormatter.taskDateFormatter.string(from: deadlineDate))
                                    .foregroundColor(Color(UIColor.colorBlue))
                                    .font(.system(size: 13))
                                }
                            }
                        }
                        Toggle("", isOn: $isOn)
                            .onTapGesture(perform: {
//                                isOn.toggle()
                                if isCalendarVisible {
                                    withAnimation {
                                        isCalendarVisible.toggle()
                                    }
                                }
                                withAnimation {
                                    isOn.toggle()
                                }
                            })
                        
                            
                    }.frame(height: 56).padding(EdgeInsets(top: -16, leading: 16, bottom: 0, trailing: 16))
                    if isCalendarVisible && isOn {
                        setDivider()
                    }
                    if isCalendarVisible && isOn {
                        DatePicker("", selection: $deadlineDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(EdgeInsets(top: -16, leading: 8, bottom: -12, trailing: 8))
                        }
           
                }.frame(maxWidth: .infinity).background(Color.white.cornerRadius(12))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Button{} label: {
                    Text("Удалить")
                        .foregroundColor(text == "" ? Color(UIColor.labelTertiary) : Color.red)
                }.frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white.cornerRadius(12))
                    .disabled(text == "" ? true: false)
                
                Spacer()
                
            }.padding()
            }
            }
            .navigationBarItems(leading: Button("Отменить") {}, trailing: Button("Сохранить") {}.font(.bold(.body)()).foregroundColor(text == "" ? Color(UIColor.labelTertiary) : Color(UIColor.colorBlue)).disabled(text == "" ? true : false))
                .navigationTitle("Дело")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func setDivider() -> some View {
        return Divider().background(Color(UIColor.supportSeparator))
            .frame(height: 1)
            .padding(EdgeInsets(top: -8, leading: 16, bottom: 0, trailing: 16))
    }
}

struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView()
    }
}
