import SwiftUI

struct BookmarksView: View {
    @Binding var isShowing: Bool
    @ObservedObject var viewModel: WebViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Bookmark.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Bookmark.name, ascending: true)
        ]
    ) var bookmarks: FetchedResults<Bookmark>

    var body: some View {
        
        ZStack {
            if #available(iOS 14.0, *) {
                Colors.bgColor.ignoresSafeArea()
            } else {
                // Fallback on earlier versions
            }
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Image(systemName: "chevron.compact.down")
                        .font(.system(size:30))
                        .padding(.top, 7)
                        .padding(.bottom, 2)
                        .opacity(0.4)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                
                Text("Bookmarks")
                    .font(.custom(FontNames.exoSemiBold, size: 22))
                    .foregroundColor(Color.white)
                
                Divider()
                VStack {
                    ForEach(bookmarks) { bookmark in
                        HStack {
                            BookmarksViewRow(siteName: bookmark.name!, link: bookmark.url!, isShowing: $isShowing, viewModel: viewModel)
                        }.padding(4)
                    }
                    .onDelete(perform: removeBookmarks)

                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
            .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Colors.bgColor)
        }
    }
    
    func removeBookmarks(at offsets: IndexSet) {
        for index in offsets {
            let bookmark = bookmarks[index]
            managedObjectContext.delete(bookmark)
        }
    }
}
