
import SwiftUI

struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)

    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

struct AddURLView: View {
//    @Binding var presentedAsModal: Bool
    @State private var url: String = ""
    var fromEdit : Bool
    var type : ListType
    var body: some View {
        VStack() {
            Spacer()
                .frame(height: 50)
            HStack() {
                Spacer()
                    .frame(width: 10)
                Button(action: {
                    // dismiss
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissModal"), object: nil)
                }) {
                    Text("Cancel")
                }
                Spacer()
                Button(action: {
                    // dismiss
                }) {
                    Text("Add")
                }
                Spacer()
                    .frame(width: 10)
            }
            TextField("Enter URL", text: $url)
            Spacer()
        }
    }
}

struct AddURLView_Previews: PreviewProvider {
    static var previews: some View {
        AddURLView(fromEdit: false, type: .whiteList)
    }
}
