import SwiftUI
import CoreData

struct DatabasesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddDatabase = false
    @State private var showingDatabaseDetail = false
    @State private var selectedDatabase: DatabaseInfo?
    @State private var databases: [DatabaseInfo] = []
    @State private var searchText = ""
    
    var filteredDatabases: [DatabaseInfo] {
        if searchText.isEmpty {
            return databases
        } else {
            return databases.filter { database in
                database.name.localizedCaseInsensitiveContains(searchText) ||
                database.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search databases...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                if filteredDatabases.isEmpty {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: "tablecells.badge.ellipsis")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No Databases Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Create structured data tables like in Notion")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Create Database") {
                            showingAddDatabase = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Databases Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(filteredDatabases) { database in
                            DatabaseCardView(database: database) {
                                selectedDatabase = database
                                showingDatabaseDetail = true
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("🗃️ Databases")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ New DB") {
                        showingAddDatabase = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddDatabase) {
            DatabaseCreatorView { newDatabase in
                databases.append(newDatabase)
            }
        }
        .sheet(isPresented: $showingDatabaseDetail) {
            if let database = selectedDatabase {
                DatabaseDetailView(database: database)
            }
        }
        .onAppear {
            loadSampleDatabases()
        }
    }
    
    private func loadSampleDatabases() {
        if databases.isEmpty {
            databases = [
                DatabaseInfo(
                    name: "📊 Project Tracker",
                    description: "Track project tasks and deadlines",
                    icon: "chart.bar.fill",
                    color: .blue,
                    recordCount: 12,
                    fields: [
                        DatabaseField(name: "Task", type: .text),
                        DatabaseField(name: "Status", type: .select),
                        DatabaseField(name: "Due Date", type: .date),
                        DatabaseField(name: "Priority", type: .select)
                    ]
                ),
                DatabaseInfo(
                    name: "👥 Contacts",
                    description: "Manage business and personal contacts",
                    icon: "person.2.fill",
                    color: .green,
                    recordCount: 45,
                    fields: [
                        DatabaseField(name: "Name", type: .text),
                        DatabaseField(name: "Email", type: .email),
                        DatabaseField(name: "Company", type: .text),
                        DatabaseField(name: "Phone", type: .phone)
                    ]
                ),
                DatabaseInfo(
                    name: "📚 Reading List",
                    description: "Track ongoing projects and milestones",
                    icon: "book.fill",
                    color: .purple,
                    recordCount: 23,
                    fields: [
                        DatabaseField(name: "Project Name", type: .text),
                        DatabaseField(name: "Status", type: .select),
                        DatabaseField(name: "Start Date", type: .date),
                        DatabaseField(name: "Budget", type: .number)
                    ]
                )
            ]
        }
    }
}

// MARK: - Database Card View

struct DatabaseCardView: View {
    let database: DatabaseInfo
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: database.icon)
                        .font(.title2)
                        .foregroundColor(database.color)
                    
                    Spacer()
                    
                    Text("\(database.recordCount)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                
                Text(database.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(database.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text("\(database.fields.count) fields")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Database Creator View

struct DatabaseCreatorView: View {
    let onSave: (DatabaseInfo) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedIcon = "tablecells"
    @State private var selectedColor: Color = .blue
    @State private var fields: [DatabaseField] = [
        DatabaseField(name: "Name", type: .text)
    ]
    
    let availableIcons = ["tablecells", "list.bullet", "folder", "tag", "bookmark", "star"]
    let availableColors: [Color] = [.blue, .green, .red, .orange, .purple, .pink]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Database Info") {
                    TextField("Database name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Appearance") {
                    HStack {
                        Text("Icon")
                        Spacer()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: { selectedIcon = icon }) {
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(selectedIcon == icon ? .white : .secondary)
                                            .frame(width: 40, height: 40)
                                            .background(selectedIcon == icon ? selectedColor : Color.clear)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Text("Color")
                        Spacer()
                        HStack {
                            ForEach(availableColors, id: \.self) { color in
                                Button(action: { selectedColor = color }) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.primary, lineWidth: selectedColor == color ? 2 : 0)
                                        )
                                }
                            }
                        }
                    }
                }
                
                Section("Fields") {
                    ForEach(fields.indices, id: \.self) { index in
                        HStack {
                            TextField("Field name", text: $fields[index].name)
                            
                            Menu(fields[index].type.displayName) {
                                ForEach(DatabaseFieldType.allCases, id: \.self) { type in
                                    Button(type.displayName) {
                                        fields[index].type = type
                                    }
                                }
                            }
                            .foregroundColor(.blue)
                            
                            if fields.count > 1 {
                                Button(action: { fields.remove(at: index) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: { fields.append(DatabaseField(name: "", type: .text)) }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Field")
                        }
                        .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("New Database")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newDatabase = DatabaseInfo(
                            name: name,
                            description: description,
                            icon: selectedIcon,
                            color: selectedColor,
                            recordCount: 0,
                            fields: fields
                        )
                        onSave(newDatabase)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

// MARK: - Database Detail View

struct DatabaseDetailView: View {
    let database: DatabaseInfo
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddRecord = false
    @State private var records: [DatabaseRecord] = []
    
    var body: some View {
        NavigationView {
            VStack {
                if records.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: database.icon)
                            .font(.system(size: 50))
                            .foregroundColor(database.color)
                        
                        Text("No Records Yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Add your first record to get started")
                            .foregroundColor(.secondary)
                        
                        Button("Add Record") {
                            showingAddRecord = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(records) { record in
                            DatabaseRecordRowView(record: record, fields: database.fields)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle(database.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddRecord = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddRecord) {
            DatabaseRecordEditorView(fields: database.fields) { newRecord in
                records.append(newRecord)
            }
        }
        .onAppear {
            loadSampleRecords()
        }
    }
    
    private func loadSampleRecords() {
        if records.isEmpty && database.name == "📊 Project Tracker" {
            records = [
                DatabaseRecord(values: [
                    "Task": "Complete app development",
                    "Status": "In Progress",
                    "Due Date": "Dec 25, 2024",
                    "Priority": "High"
                ]),
                DatabaseRecord(values: [
                    "Task": "Review code",
                    "Status": "Todo",
                    "Due Date": "Dec 20, 2024",
                    "Priority": "Medium"
                ])
            ]
        }
    }
}

// MARK: - Supporting Views and Types

struct DatabaseRecordRowView: View {
    let record: DatabaseRecord
    let fields: [DatabaseField]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(fields.prefix(3), id: \.name) { field in
                HStack {
                    Text(field.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(record.values[field.name] ?? "—")
                        .font(.body)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct DatabaseRecordEditorView: View {
    let fields: [DatabaseField]
    let onSave: (DatabaseRecord) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var values: [String: String] = [:]
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(fields, id: \.name) { field in
                    HStack {
                        Text(field.name)
                            .frame(width: 100, alignment: .leading)
                        
                        TextField("Enter \(field.name.lowercased())", text: Binding(
                            get: { values[field.name] ?? "" },
                            set: { values[field.name] = $0 }
                        ))
                        .textFieldStyle(.roundedBorder)
                    }
                }
            }
            .navigationTitle("New Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newRecord = DatabaseRecord(values: values)
                        onSave(newRecord)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Data Models

struct DatabaseInfo: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let color: Color
    let recordCount: Int
    let fields: [DatabaseField]
}

struct DatabaseField: Identifiable {
    let id = UUID()
    var name: String
    var type: DatabaseFieldType
}

struct DatabaseRecord: Identifiable {
    let id = UUID()
    let values: [String: String]
}

enum DatabaseFieldType: CaseIterable {
    case text
    case number
    case date
    case select
    case email
    case phone
    case url
    
    var displayName: String {
        switch self {
        case .text: return "Text"
        case .number: return "Number"
        case .date: return "Date"
        case .select: return "Select"
        case .email: return "Email"
        case .phone: return "Phone"
        case .url: return "URL"
        }
    }
}

struct DatabasesView_Previews: PreviewProvider {
    static var previews: some View {
        DatabasesView()
    }
} 