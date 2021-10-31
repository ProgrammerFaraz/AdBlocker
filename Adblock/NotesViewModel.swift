//
//  NotesViewModel.swift
//  Notes
//
//  Created by John Royal on 7/10/21.
//

import Foundation

class NotesViewModel: ObservableObject {
  @Published var notes: [Note] = []
  @Published var editingNote: Note.ID?
  
  /// Creates a new note, then updates the navigation state so that the `EditNoteView` is displayed for the new note.
  func createNote() {
    let note = Note(id: UUID(), title: "New Note", content: "")
    notes.append(note)
    
    // Update state to show the EditNoteView for the new note
    editingNote = note.id
  }
  
  /// Deletes one or more notes. This is used to enable SwiftUI’s built-in delete functionality.
  /// - Parameter indexSet: Indices in the `notes` array for the notes being removed.
  func handleDelete(_ indexSet: IndexSet) {
    notes.remove(atOffsets: indexSet)
  }
  
  // MARK: - Persistence
  // Add your code here
  
  private var documentDirectory: URL {
    try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  }
  
  private var notesFile: URL {
    return documentDirectory
      .appendingPathComponent("notes")
      .appendingPathExtension(for: .json)
  }
  
  func load() throws {
    guard FileManager.default.isReadableFile(atPath: notesFile.path) else { return }
    let data = try Data(contentsOf: notesFile)
    notes = try JSONDecoder().decode([Note].self, from: data)
  }
  
  func save() throws {
    let data = try JSONEncoder().encode(notes)
    try data.write(to: notesFile)
  }
}
