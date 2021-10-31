
import SwiftUI

struct HowToUseView: View {
    
    @State private var currentPage = 0
    @ViewBuilder var buttonText: some View {
        if currentPage == 3 {
            Text("Done")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 65)
                .font(.title)
                .background(Color("AppRed"))
                .cornerRadius(35)
                .foregroundColor(Color.white)
                .padding([.leading, .trailing], 50)
        }else {
            Text("Next")
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 65)
                .font(.title)
                .background(Color.gray)
                .cornerRadius(35)
                .foregroundColor(Color.white)
                .padding([.leading, .trailing], 50)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 100)
            PagerView(pageCount: 4, currentIndex: $currentPage) {
                Image("howtouse-1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
                Image("howtouse-2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
                Image("howtouse-3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
                Image("howtouse-4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding([.leading, .trailing], 20)
            }
            VStack(alignment: .leading) {
                Text("Step \(currentPage + 1)")
                    .padding(.leading, 25)
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
                containedIndex()
                    .padding(.leading, 25)
                Spacer()
                    .frame(height: 25)
            }

            HStack(){
                Spacer()
                Button(action: {
                    nextTapped()
                }) {
                    buttonText
                }
                Spacer()
            }
            PageControl(selectedPage: $currentPage, pages: 4, circleDiameter: 50, circleMargin: 10)
                .padding(.trailing)
            Spacer()
                .frame(height: 50)
        }
    }
    
    func containedIndex() -> Text {
        switch currentPage {
        case 0:
            return Text("Go to Setting App")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 1:
            return Text("Go to Safari")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 2:
            return Text("Go to the Content")
                .font(.system(size: 20, weight: .bold, design: .default))
        case 3:
            return Text("Find Adblocker and Enable")
                .font(.system(size: 20, weight: .bold, design: .default))
        default: break
        }
        return Text("")
    }
    
    func nextTapped() {
        if currentPage == 3 {
            currentPage = 0
        }else {
            currentPage += 1
        }
    }
}


struct HowToUseView_Previews: PreviewProvider {
    static var previews: some View {
        HowToUseView()
    }
}
