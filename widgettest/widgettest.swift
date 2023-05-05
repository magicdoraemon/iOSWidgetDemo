//
//  widgettest.swift
//  widgettest
//
//  Created by Doraemon on 2023/5/5.
//

import WidgetKit
import SwiftUI

struct TodoItem: Codable, Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),datas: [TodoItem(id:UUID(), title: "", isCompleted: false)])
    }
    //预览图
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),datas: [TodoItem(id: UUID(), title: "", isCompleted: false),TodoItem(id: UUID(), title: "", isCompleted: false),TodoItem(id: UUID(), title: "", isCompleted: false),TodoItem(id: UUID(), title: "", isCompleted: false),TodoItem(id: UUID(), title: "", isCompleted: false)])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.WZX.todotest")!.appendingPathComponent("todos.json")
        do {
            let data = try Data(contentsOf: url)
            let todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, datas: todoItems)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } catch {
            // Handle the error here
            print("Error reading data from file: \(error.localizedDescription)")
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let datas : [TodoItem]
}

struct widgettestEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        if widgetFamily == .systemSmall{
            ZStack {
                Text("")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                VStack{
                    ForEach(entry.datas.prefix(3)) { singledata in
                        Text(singledata.title)
                            .frame(width: 130,height: 38, alignment: .center)
                            .padding(.leading, 8)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 6, x: 0, y: 0)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
                    .padding()
            }
        }
        
        if widgetFamily == .systemMedium{
            VStack{
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(entry.datas.prefix(6)) { singledata in

                        Text(singledata.title)
                            .frame(width: 130,height: 38, alignment: .center)
                            .padding(.leading, 8)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 5, x: 0, y: 0)
                    }
                }
                .frame(maxHeight: .infinity,alignment: .top)
                .padding()
                .background(.ultraThinMaterial)
            }
        }

        if widgetFamily == .systemLarge{
            VStack{
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(entry.datas.prefix(14)) { singledata in
                        Text(singledata.title)
                            .frame(width: 130,height: 38, alignment: .center)
                            .padding(.leading, 8)
                            .background(.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: 5, x: 0, y: 0)
                    }
                }
                .frame(maxHeight: .infinity,alignment: .top)
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}

struct widgettest: Widget {
    let kind: String = "widgettest"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            widgettestEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widgettest_Previews: PreviewProvider {
    static var previews: some View {
        widgettestEntryView(entry: SimpleEntry(date: Date(),datas: [TodoItem(id: UUID(), title: "测试1", isCompleted: false), TodoItem(id: UUID(), title: "测试2", isCompleted: false), TodoItem(id: UUID(), title: "测试3", isCompleted: false)]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        widgettestEntryView(entry: SimpleEntry(date: Date(),datas: [TodoItem(id: UUID(), title: "测试1", isCompleted: false), TodoItem(id: UUID(), title: "测试2", isCompleted: false), TodoItem(id: UUID(), title: "测试3", isCompleted: false), TodoItem(id: UUID(), title: "测试4", isCompleted: false), TodoItem(id: UUID(), title: "测试5", isCompleted: false), TodoItem(id: UUID(), title: "测试6", isCompleted: false)]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        widgettestEntryView(entry: SimpleEntry(date: Date(),datas: [TodoItem(id: UUID(), title: "测试1", isCompleted: false), TodoItem(id: UUID(), title: "测试2", isCompleted: false), TodoItem(id: UUID(), title: "测试3", isCompleted: false), TodoItem(id: UUID(), title: "测试4", isCompleted: false), TodoItem(id: UUID(), title: "测试5", isCompleted: false), TodoItem(id: UUID(), title: "测试6", isCompleted: false), TodoItem(id: UUID(), title: "测试7", isCompleted: false), TodoItem(id: UUID(), title: "测试8", isCompleted: false), TodoItem(id: UUID(), title: "测试9", isCompleted: false), TodoItem(id: UUID(), title: "测试10", isCompleted: false), TodoItem(id: UUID(), title: "测试11", isCompleted: false), TodoItem(id: UUID(), title: "测试12", isCompleted: false), TodoItem(id: UUID(), title: "测试13", isCompleted: false), TodoItem(id: UUID(), title: "测试14", isCompleted: false)]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
