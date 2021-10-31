import SwiftUI
import Drops

struct EditNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var note: Note
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .offset(x: -2, y: 2)
                    }).foregroundColor(Colors.blueColor)
                    Text("Edit “\(note.title)”")
                        .foregroundColor(.white)
                        .font(.custom(FontNames.exoSemiBold, size: 22))
                    Spacer()
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                Form {
                    Section(header: Text("Title")) {
                        TextField("Title", text: $note.title)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.02))
                    Section(header: Text("Note")) {
                        TextEditor(text: $note.content)
                            .foregroundColor(.white)
                            .frame(min: CGSize(width: 0, height: 250))
                    }
                    .listRowBackground(Color.white.opacity(0.02))
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        Drops.show(Drop(title: "Note saved successfully"))
                    }, label: {
                        Text("Save")
                            .bold()
                            .fill(alignment: .center)
                    })
                    .font(.custom(FontNames.exo, size: 18))
                    .listRowBackground(Colors.blueColor)
                    .foregroundColor(.white)
                }
                .font(.custom(FontNames.exo, size: 18))
                .navigationBarHidden(true)
                .onAppear() {
                    UITableView.appearance().backgroundColor = .clear
                    UITableViewCell.appearance().backgroundColor = UIColor.clear
                }
            }
        }
    }
}

struct EditNoteView_Previews: PreviewProvider {
    @State private static var note = Note(id: UUID(), title: "New Note", content: "This is some content...")
    
    static var previews: some View {
        NavigationView {
            EditNoteView(note: $note)
        }
    }
}
