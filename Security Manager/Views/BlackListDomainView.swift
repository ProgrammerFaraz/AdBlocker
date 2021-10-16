//
//  BlackListDomainView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 01.09.2021.
//

import SwiftUI
import Drops

struct BlackListDomainView: View {
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
    }
    
    @State var domains: [String] = []
    @State var domainText: String = ""
    
    @State var isActivated = true
    @State var showingHintView = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                if #available(iOS 14.0, *) {
                    Colors.bgColor.ignoresSafeArea()
                } else {
                    // Fallback on earlier versions
                }
                VStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .offset(x: -2, y: 2)
                        }).foregroundColor(Colors.blueColor)
                        Text("Website Block")
                            .foregroundColor(.white)
                            .font(.custom(FontNames.exoSemiBold, size: 22))
                        Spacer()
                    }.padding([.top, .leading, .trailing])
                    Spacer().frame(height: 18)
                    Color.white.frame(height: 1).opacity(0.08)
                    if #available(iOS 14.0, *) {
                        List {
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
                                    Drops.show(Drop(title: "enter the domain in the format: domain.com"))
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
                        .font(.custom(FontNames.exo, size: 18))
                        .navigationBarHidden(true)
                        .listStyle(InsetGroupedListStyle())
                        .foregroundColor(.white)
                    } else {
                        // Fallback on earlier versions
                    }
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
                                                BlockManager.shared.activateFilters { error in
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
            .font(.custom(FontNames.exo, size: 18))
        }
        .onChange(of: domains) { _ in
            BlockManager.shared.blockDomains = domains
            
            isActivated = false
        }
        .onAppear() {
            domains = BlockManager.shared.blockDomains
            
            BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
            })
        }
        .onChange(of: isActivated, perform: { value in
            if !value {
                //BlockManager.shared.deactivateFilters { _ in }
            }
        })
        .sheet(isPresented: $showingHintView) {
            HintView()
        }
    }
}

struct BlackListDomainView_Previews: PreviewProvider {
    static var previews: some View {
        BlackListDomainView()
    }
}
