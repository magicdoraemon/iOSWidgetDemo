//
//  todo_testApp.swift
//  todoTest
//
//  Created by Doraemon on 2023/5/5.
//

import SwiftUI

@main
struct todo_testApp: App {
    @StateObject var todoManager = TodoManager()
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(TodoManager())
        }
    }
}
