import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search everything...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    SearchResultRow(title: "Meeting notes", type: "Voice Note", date: Date())
                    SearchResultRow(title: "Project ideas", type: "Note", date: Date())
                    SearchResultRow(title: "Contact list", type: "Database", date: Date())
                    SearchResultRow(title: "Daily standup", type: "Voice Note", date: Date())
                    SearchResultRow(title: "Team contacts", type: "Database", date: Date())
                }
                
                Spacer()
            }
            .navigationTitle("🔍 Search")
        }
    }
}

struct SearchResultRow: View {
    let title: String
    let type: String
    let date: Date
    
    var body: some View {
        HStack {
            Image(systemName: iconForType(type))
                .foregroundColor(colorForType(type))
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                HStack {
                    Text(type)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func iconForType(_ type: String) -> String {
        switch type {
        case "Note": return "note.text"
        case "Voice Note": return "waveform"
        case "Database": return "square.grid.3x3"
        default: return "doc"
        }
    }
    
    private func colorForType(_ type: String) -> Color {
        switch type {
        case "Note": return .blue
        case "Voice Note": return .red
        case "Database": return .green
        default: return .gray
        }
    }
}

#Preview {
    SearchView()
} 