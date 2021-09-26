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
    @State private var showNewTaskITem: Bool = false

    @Environment(\.managedObjectContext) private var viewContext

    // FETCHING DATA
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

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
            ZStack(content: {
                // MARK: - MAIN VIEW

                VStack(content: {
                    // MARK: - HEADER

                    Spacer(minLength: 80)

                    // MARK: - NEW TASK BUTTON

                    Button(action: {
                        showNewTaskITem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New task")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                    })
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0, y: 4)

                    // MARK: - TASKS

                    List(content: {
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
                    })
                        .onAppear(perform: {
                            UITableView.appearance().backgroundColor = UIColor.clear
                        })
                        .listStyle(InsetGroupedListStyle())
                        .navigationBarTitle("Dailty tasks", displayMode: .large)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                        .toolbar(content: {
                            #if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                            #endif

                        }) //: TOOLBAR
                })
                    .background(BackgroundImageView())
                    .background(backgroundGradient.ignoresSafeArea(.all))

                // MARK: - NEW TASK ITEM

                if showNewTaskITem {
                    BlankView()
                        .onTapGesture(perform: {
                            withAnimation {
                                showNewTaskITem = false
                            }
                        })

                    NewTaskItemView(isShowing: $showNewTaskITem)
                }
            }) //: ZSTACK
        } //: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
