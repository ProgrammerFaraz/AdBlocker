//
//  BlackWhiteListView.swift
//  Security Manager
//
//  Created by Faraz on 10/9/21.
//

import SwiftUI
import Drops

enum ListType {
    case whiteList
    case blackList
}

struct WhiteListData {
    let url : String
}

struct BlackListData {
    let url : String
}

struct BlackWhiteListView: View {
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    var type: ListType
    lazy var viewModel: BlackWhiteListViewModel = {
        return BlackWhiteListViewModel()
    }()
    
    @State var domains: [String] = []
    @State var domainText: String = ""
    
    @State var isActivated = true
    @State var showingHintView = false
    
    
    @ViewBuilder var list: some View {
        
        NavigationView {
            List{
                Section(header: Text("Block list").foregroundColor(.gray).font(.custom(FontNames.exo, size: 14))) {
                    Text("example.com")
                        .listRowBackground(Color.white.opacity(0.02))
                    ForEach(domains, id: \.self) { domain in
                        Text(domain)
                            .listRowBackground(Color.white.opacity(0.02))
                    }
                    .onDelete(perform: { index in
                        domains.remove(atOffsets: index)
                    })
                }
                Section(header: Text("add domain").foregroundColor(.gray).font(.custom(FontNames.exo, size: 14))) {
                    TextField("domain.com", text: $domainText)
                        .listRowBackground(Color.white.opacity(0.02))
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                Button(action: {
                    if domainText == "" { return }
                    if !domainText.contains(".") {
                        Drops.show(Drop(title: "Invalid Domain, please enter again."))
                        return
                    }
                    withAnimation() {
                        domains.append(domainText)
                        domainText = ""
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Text("Add to list")
                        .bold()
                        .fill(alignment: .center)
                })
                .font(.custom(FontNames.exo, size: 18))
                .listRowBackground(Colors.blueColor)
            }
        }
        .onChange(of: domains) { _ in
            if type == .blackList {
                BlockManager.shared.blockDomains = domains
                isActivated = false
            }else {
                BlockManager.shared.trustDomains = domains
                isActivated = false
            }
        }
        .onAppear() {
            if type == .blackList {
                domains = BlockManager.shared.blockDomains
                BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
                })
            }else {
                domains = BlockManager.shared.trustDomains
                BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
                })
            }
            
        }
        .navigationTitle(setupNavigationTitle(type: self.type))
    }
    
    var body: some View {
        list
    }
    
    func setupNavigationTitle(type: ListType) -> String {
        return "\(self.type == .blackList ? "Black List" : "White List")"
    }
}

struct BlackWhiteListView_Previews: PreviewProvider {
    static var previews: some View {
        BlackWhiteListView(type: .whiteList)
    }
}
