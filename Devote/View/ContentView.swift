//
//  ContentView.swift
//  Devote
//
//  Created by Cat on 22.09.2021.
//

import CoreData
import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES

    @State var task: String = ""
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }

    @Environment(\.managedObjectContext) private var viewContext

    // FETCHING DATA
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - FUNCTION

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16, content: {
                    if #available(iOS 15.0, *) {
                        TextField("New task", text: $task)
                            .padding()
                            .background(Color(uiColor: .systemGray6))
                            .cornerRadius(10)

                        Button(action: {
                            addItem()
                        }, label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        })
                            .disabled(isButtonDisabled)
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(isButtonDisabled ? Color.gray : Color.pink)
                            .cornerRadius(10)
                    } else {
                        // Fallback on earlier versions
                        TextField("New task", text: $task)
                            .padding()
                            .background(Color(.gray))
                            .cornerRadius(10)
                    }
                }) //: VSTACK
                    .padding()
 
                List {
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.task ?? "")
                                .font(.headline)
                                .fontWeight(.bold)

                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        } //: VSTACK
                    } //: LOOP
                    .onDelete(perform: deleteItems)
                } //: LIST
                .navigationBarTitle("Dailty tasks", displayMode: .large)
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    #endif
                } //: TOOLBAR
            } //: VSTACK
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
