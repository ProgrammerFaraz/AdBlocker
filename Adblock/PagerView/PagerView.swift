
import SwiftUI

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content
    
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring(), value: currentIndex)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
//            PageControl(selectedPage: .constant(0),
//                        pages: self.pageCount,
//                        circleDiameter: 15.0,
//                        circleMargin: 10.0)
        }
    }
}


struct PageControl: View {
    
    @Binding var selectedPage: Int
    
    var pages: Int
    var circleDiameter: CGFloat
    var circleMargin: CGFloat
    
    var body: some View {
        ZStack {
            // Total number of pages
            HStack(spacing: circleMargin) {
                ForEach(0 ..< pages) { _ in
                    Circle()
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: circleDiameter, height: circleDiameter)
                }
            }
            
            // Current page index
            Circle()
                .foregroundColor(.black)
                .frame(width: circleDiameter, height: circleDiameter)
        }
    }
}
