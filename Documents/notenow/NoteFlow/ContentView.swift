import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        TabView {
            NotesView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Notes")
                }
            
            DatabasesView()
                .tabItem {
                    Image(systemName: "square.grid.3x3")
                    Text("Databases")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            VoiceNotesView()
                .tabItem {
                    Image(systemName: "mic.fill")
                    Text("Voice Notes")
                }
            
            WorkflowsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Workflows")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 