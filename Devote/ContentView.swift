//
//  ContentView.swift
//  Devote
//
//  Created by Kshitij Singh Chauhan on 13/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - PROPERTY
    
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - FUNCTIONS
    
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
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                    // MARK: - HEADER
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    Button {
                        showNewTaskItem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [Color.pink, Color.blue]),
                            startPoint: .leading, endPoint: .trailing
                        )
                        .clipShape(Capsule())
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0, y: 4)

                    
                    // MARK: - TASKS
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
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VSTACK
                
                // MARK: - NEW TASK ITEM
                
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            } //: ZSTACK
            .navigationTitle("Daily Task")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(backgroundGradient.ignoresSafeArea(.all))
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
