import SwiftUI

struct URLBarView: View {
    @ObservedObject var viewModel: WebViewModel
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        VStack {
            HStack{
                HStack{
                    Image(systemName: "globe")
                        .padding(.horizontal, 2)
                        .foregroundColor(Colors.blueColor)
                    
                    TextField("Enter URL...",text: $viewModel.url, onCommit: {commitURL()})
                        .foregroundColor(.white)
                        .padding(4)
                        .font(.custom(FontNames.exo, size: 15))
                        .keyboardType(.webSearch)
                 
                    Spacer()
                    //Add current text val to bookmarks
                    Button(action:{
                        viewModel.webViewNavigationPublisher.send(.reload)
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size:16))
                            .foregroundColor(Colors.blueColor)
                            .padding(.horizontal, 5)
                    }
                }
                .padding(5)
                .cornerRadius(4.0)
                .background(Capsule().strokeBorder(Color.white.opacity(0.08), lineWidth: 1.25 ))
                Button(action:{
                    let bookmark = Bookmark(context: managedObjectContext)
                    bookmark.name = viewModel.showWebTitle
                    bookmark.url = viewModel.url
                    PersistenceController.shared.saveContext()
                    
                }) {
                    Image(systemName: "bookmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Colors.blueColor)
                        .padding(5)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 5)
        }
    }
    
    func commitURL(){
            viewModel.webViewNavigationPublisher.send(WebViewNavigation.load)
    }
}

