import SwiftUI
import AVFoundation

struct VoiceNotesView: View {
    @State private var isRecording = false
    @State private var recordings: [VoiceRecording] = [
        VoiceRecording(title: "Meeting Notes", duration: 180, date: Date().addingTimeInterval(-3600)),
        VoiceRecording(title: "Ideas for App", duration: 120, date: Date().addingTimeInterval(-7200)),
        VoiceRecording(title: "Grocery List", duration: 45, date: Date().addingTimeInterval(-86400))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Recording Section
                VStack(spacing: 20) {
                    Circle()
                        .fill(isRecording ? Color.red : Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "mic.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        )
                        .scaleEffect(isRecording ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isRecording)
                    
                    Button(isRecording ? "Stop Recording" : "Start Recording") {
                        toggleRecording()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
                }
                .padding()
                
                Divider()
                
                // Recordings List
                List {
                    ForEach(recordings) { recording in
                        HStack {
                            Image(systemName: "waveform")
                                .foregroundColor(.blue)
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text(recording.title)
                                    .font(.headline)
                                
                                HStack {
                                    Text(formatDuration(recording.duration))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    
                                    Text(recording.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                // Play recording
                            } label: {
                                Image(systemName: "play.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteRecordings)
                }
            }
            .navigationTitle("🎤 Voice Notes")
        }
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        
        if isRecording {
            // Start recording logic
        } else {
            // Stop recording and add to list
            let newRecording = VoiceRecording(
                title: "Recording \(recordings.count + 1)",
                duration: Int.random(in: 30...300),
                date: Date()
            )
            recordings.insert(newRecording, at: 0)
        }
    }
    
    private func deleteRecordings(offsets: IndexSet) {
        recordings.remove(atOffsets: offsets)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

struct VoiceRecording: Identifiable {
    let id = UUID()
    let title: String
    let duration: Int // in seconds
    let date: Date
}

#Preview {
    VoiceNotesView()
} 