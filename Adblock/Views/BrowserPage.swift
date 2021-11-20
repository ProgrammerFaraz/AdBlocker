//
//import SwiftUI
//
//@available(iOS 14.0, *)
//struct BrowserPage: View{
//    let persistenceController = PersistenceController.shared
//    @Environment(\.scenePhase) var scenePhase
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    @ObservedObject var viewModel = WebViewModel()
//    
//    var body: some View {
//        ZStack {
//            Colors.bgColor.ignoresSafeArea()
//            VStack{
//                HStack {
//                    Button(action: {
//                        presentationMode.dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .padding(.leading)
//                            .foregroundColor(Colors.blueColor)
//                            .font(.system(size: 20))
//                            .offset(y: 2)
//                    }
//                    URLBarView(viewModel: viewModel)
//                }
//                
//                HStack{
//                    WebView(viewModel: viewModel)
//                }
//                
//                BottomNavBarView(viewModel: viewModel)
//                    .padding(.bottom, 25)
//            }
//            .background(Colors.bgColor)
//            .onChange(of: scenePhase) { _ in
//                persistenceController.saveContext()
//            }
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
//        }
//    }
//}
//
//
//struct BrowserPage_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 14.0, *) {
//            BrowserPage()
//                .preferredColorScheme(.dark)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
