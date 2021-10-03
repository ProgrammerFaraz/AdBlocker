import SwiftUI

struct BookmarksViewRow: View {
    var siteName: String
    var link: String
    @Binding var isShowing: Bool
    @State var isSwiped: Bool = false
    @State var offset: CGFloat = 0.0
    @ObservedObject var viewModel: WebViewModel
    @FetchRequest(
        entity: Bookmark.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Bookmark.url, ascending: true),
        ]
    ) var bookmarkesDelete: FetchedResults<Bookmark>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(siteName)
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                    .font(.custom(FontNames.exoSemiBold, size: 18))
                Spacer().frame(height: 3)
                Text(link)
                    .font(.custom(FontNames.exoSemiBold, size: 14))
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                    .opacity(0.6)
            }
            .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.horizontal, 10)
        .onTapGesture {
            viewModel.url = link
            viewModel.webViewNavigationPublisher.send(.load)
            isShowing.toggle()
        }
    }
}
