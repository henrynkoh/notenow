import SwiftUI

struct DatabasesView: View {
    @State private var databases = [
        Database(name: "📊 Project Tracker", records: 12),
        Database(name: "👥 Contacts", records: 45),
        Database(name: "📚 Reading List", records: 23)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(databases) { database in
                    HStack {
                        Text(database.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(database.records) records")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("🗃️ Databases")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ New") {
                        // Add new database
                    }
                }
            }
        }
    }
}

struct Database: Identifiable {
    let id = UUID()
    let name: String
    let records: Int
}

#Preview {
    DatabasesView()
} 