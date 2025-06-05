import SwiftUI

struct WorkflowsView: View {
    @State private var workflows = [
        Workflow(name: "📧 Email Meeting Notes", trigger: "Voice Note Created", action: "Send Email", isActive: true),
        Workflow(name: "📱 Slack Project Updates", trigger: "Database Updated", action: "Post to Slack", isActive: true),
        Workflow(name: "📅 Calendar Reminders", trigger: "Schedule", action: "Create Event", isActive: false)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(workflows) { workflow in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workflow.name)
                                .font(.headline)
                            
                            HStack {
                                Text("🔧 \(workflow.trigger)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("→")
                                    .foregroundColor(.secondary)
                                
                                Text("⚡ \(workflow.action)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { workflow.isActive },
                            set: { newValue in
                                if let index = workflows.firstIndex(where: { $0.id == workflow.id }) {
                                    workflows[index].isActive = newValue
                                }
                            }
                        ))
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteWorkflows)
            }
            .navigationTitle("⚙️ Workflows")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+ New") {
                        // Add new workflow
                    }
                }
            }
        }
    }
    
    private func deleteWorkflows(offsets: IndexSet) {
        workflows.remove(atOffsets: offsets)
    }
}

struct Workflow: Identifiable {
    let id = UUID()
    let name: String
    let trigger: String
    let action: String
    var isActive: Bool
}

#Preview {
    WorkflowsView()
} 