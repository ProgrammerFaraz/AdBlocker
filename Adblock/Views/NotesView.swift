import SwiftUI

struct NotesView: View {
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    
    @StateObject var viewModel = NotesViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                Colors.bgColor.ignoresSafeArea()
                VStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .offset(x: -2, y: 2)
                        }).foregroundColor(Colors.blueColor)
                        Text("Secure notes")
                            .foregroundColor(.white)
                            .font(.custom(FontNames.exoSemiBold, size: 22))
                        Spacer()
                        Button(action: { viewModel.createNote() }) {
                            Image(systemName: "plus").font(.system(size: 22))
                        }.foregroundColor(Colors.blueColor)
                    }.padding([.top, .leading, .trailing])
                    Spacer().frame(height: 18)
                    Color.white.frame(height: 1).opacity(0.08)
                    List {
                      ForEach(viewModel.notes) { note in
                        NavigationLink(
                          note.title,
                          destination: EditNoteView(note: binding(for: note)),
                          tag: note.id,
                          selection: $viewModel.editingNote
                        )
                        .listRowBackground(Color.white.opacity(0.02))
                      }
                      .onDelete(perform: viewModel.handleDelete(_:))
                    }
                    .font(.custom(FontNames.exo, size: 18))
                    .navigationBarHidden(true)
                    .listStyle(InsetGroupedListStyle())
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            try! viewModel.load()
        }
        .onChange(of: viewModel.notes) { _ in
            try! viewModel.save()
        }
    }
    
    private func binding(for note: Note) -> Binding<Note> {
        guard let index = viewModel.notes.firstIndex(of: note) else {
            fatalError("Cannot find note: \(note)")
        }
        return $viewModel.notes[index]
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
