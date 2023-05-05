//
//  ContentView.swift
//  todoTest
//
//  Created by Doraemon on 2023/5/5.
//
import SwiftUI
import WidgetKit

// Define a struct for the todo item
struct TodoItem: Codable, Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

class TodoManager: ObservableObject {
    @Published var todoItems: [TodoItem] = []
    
    // Initialize the todo items from the saved data
    init() {
        loadData()
    }
    
    // Save the todo items to file
    func saveData() {
        do {
            // Save the todo items to file
            let data = try JSONEncoder().encode(todoItems)
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.WZX.todotest")!.appendingPathComponent("todos.json")
            try data.write(to: url)
            //刷新指定的widget数据
            WidgetCenter.shared.reloadTimelines(ofKind: "group.WZX.todotest")
            // 刷新全部组件
//            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    // Load the todo items from file
    func loadData() {
        do {
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.WZX.todotest")!.appendingPathComponent("todos.json")
            let data = try Data(contentsOf: url)
            todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
    
    // Add a new todo item
    func addTodoItem(title: String) {
        let newTodoItem = TodoItem(id: UUID(), title: title, isCompleted: false)
        todoItems.append(newTodoItem)
        saveData()
    }
    
    func deleteAllTodoItem(){
       
        todoItems.removeAll()
        saveData()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // Toggle the completion status of a todo item
    func toggleTodoItemCompletion(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems[index].isCompleted.toggle()
            saveData()
        }
    }
    
    // Delete a todo item
    func deleteTodoItem(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems.remove(at: index)
            saveData()
        }
    }
}

// Define a view for the todo list
struct ContentView: View {
    @EnvironmentObject var todoManager: TodoManager
    @State var opensheet = false
    @State var inputtext : String = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(todoManager.todoItems) { todoitem in
                    HStack {
                        Text("\(todoitem.title)")
                    }
                }
            }.navigationTitle("Todo")
            .toolbar {
                Button {
                    print(todoManager.todoItems)
                    inputtext = ""
                    opensheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                
                
                Button {
                    todoManager.deleteAllTodoItem()
                    WidgetCenter.shared.reloadTimelines(ofKind: "group.WZX.todotest")
//                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Image(systemName: "trash")
                }
                
            }
        }
        .sheet(isPresented: $opensheet) {
            
            Form{
                TextField("", text: $inputtext)
                    .textFieldStyle(.roundedBorder)
                Button {
                    todoManager.addTodoItem(title: inputtext)
                    WidgetCenter.shared.reloadAllTimelines()
                    //刷新指定的widget数据
//                    WidgetCenter.shared.reloadTimelines(ofKind: "group.WZX.todotest")
                    opensheet.toggle()
                } label: {
                    Text("保存")
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TodoManager())
    }
}
