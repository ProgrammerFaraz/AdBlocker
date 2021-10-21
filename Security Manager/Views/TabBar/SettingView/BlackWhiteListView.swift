//
//  BlackWhiteListView.swift
//  Security Manager
//
//  Created by Faraz on 10/9/21.
//

import SwiftUI
import Drops
import Introspect

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
    
    @State var uiTabarController: UITabBarController?

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
            ZStack {
                List{
                    Section(header: Text(setupSectionHeaderTitle(type: self.type)).foregroundColor(.gray).font(.system(size: 17, weight: .semibold, design: .rounded))) {
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
                    Section(header: Text("add domain").foregroundColor(.gray).font(.system(size: 17, weight: .semibold, design: .rounded))) {
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
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .listRowBackground(Colors.blueColor)
                }
                if #available(iOS 14.0, *) {
                    VStack {
                        Spacer()
                        if !isActivated {
                            Spacer()
                            MTSlideToOpen(thumbnailTopBottomPadding: 4,
                                          thumbnailLeadingTrailingPadding: 4,
                                          text: "Slide to Save",
                                          textColor: .white,
                                          thumbnailColor: Color.white,
                                          sliderBackgroundColor: Colors.greenColor,
                                          didReachEndAction: { view in
                                if !BlockManager.shared.isExtensionActive {
                                    showingHintView = true
                                    view.resetState()
                                } else {
                                    view.isLoading = true
                                    if self.type == .blackList {
                                        BlockManager.shared.activateBlockFilters { error in
                                            view.isLoading = false
                                            if error != nil {
                                                Drops.show(Drop(title: error!.localizedDescription))
                                                view.resetState()
                                            } else {
                                                withAnimation() {
                                                    isActivated = true
                                                }
                                            }
                                        }
                                    }else {
                                        BlockManager.shared.activateWhiteFilters { error in
                                            view.isLoading = false
                                            if error != nil {
                                                Drops.show(Drop(title: error!.localizedDescription))
                                                view.resetState()
                                            } else {
                                                withAnimation() {
                                                    isActivated = true
                                                }
                                            }
                                        }
                                    }
                                }
                            })
                                .transition(.opacity)
                                .animation(.default)
                                .frame(width: 320, height: 56)
                                .cornerRadius(28)
                                .padding()
                                .background(Color.white.opacity(0.06))
                                .background(Colors.bgColor)
                                .cornerRadius(42)
                                .shadow(radius: 30)
                            Spacer().frame(height: 40)
                        }
                    }
                    .ignoresSafeArea()
                } else {
                    // Fallback on earlier versions
                }
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
            UITabBar.appearance().isHidden = true
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
        .onChange(of: isActivated, perform: { value in
            if !value {
                //BlockManager.shared.deactivateFilters { _ in }
            }
        })
        .sheet(isPresented: $showingHintView) {
            HintView()
        }
        .navigationTitle(setupNavigationTitle(type: self.type))
        .introspectTabBarController { (UITabBarController) in
            withAnimation(.easeInOut(duration: 1.0)) {
                UITabBarController.tabBar.isHidden = true
            }
            uiTabarController = UITabBarController
        }.onDisappear{
            withAnimation(.easeInOut(duration: 1.0)) {
                uiTabarController?.tabBar.isHidden = false
            }
        }

    }
    
    var body: some View {
        list
    }
    
    func setupNavigationTitle(type: ListType) -> String {
        return "\(self.type == .blackList ? "Black List" : "White List")"
    }
    
    func setupSectionHeaderTitle(type: ListType) -> String {
        return "\(self.type == .blackList ? "Block List" : "Trust List")"
    }
}

struct BlackWhiteListView_Previews: PreviewProvider {
    static var previews: some View {
        BlackWhiteListView(type: .whiteList)
    }
}
