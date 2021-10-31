import SwiftUI
struct BottomNavBarView: View {
    @ObservedObject var viewModel: WebViewModel
    @State var isShowingBookmarks = false
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                HStack {
                    Button(action:{
                        viewModel.webViewNavigationPublisher.send(.backward)
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size:25))
                            .foregroundColor(Colors.blueColor)
                            .padding(5)
                        
                    }
                    .padding(.leading, 5)
                    
                    Button(action:{
                        viewModel.webViewNavigationPublisher.send(.forward)
                    }) {
                        Image(systemName: "arrow.forward")
                            .font(.system(size:25))
                            .foregroundColor(Colors.blueColor)
                            .padding(5)
                    }
                    .padding(5)
                    .padding(.vertical, 5)

                    Spacer()
                    
                    HStack{
                        Button(action:{
                            isShowingBookmarks.toggle()
                        }) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Colors.blueColor)
                                .padding(5)
                        }
                    }
                }
                .sheet(isPresented: $isShowingBookmarks, content: {
                    BookmarksView(isShowing: $isShowingBookmarks, viewModel: viewModel)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                })
                Spacer()
            }
            Spacer()
        }
    }
}
