////
////  PasswordListView.swift
////  PasswordGenerator
////
////  Created by Iliane Zedadra on 06/05/2021.
////
//
//import SwiftUI
//import SwiftUIX
//import Security
//import KeychainSwift
//
//struct PasswordListView: View {
//    
//    init() {
//        UITableView.appearance().backgroundColor = .clear
//        UITableViewCell.appearance().backgroundColor = UIColor.clear
//    }
//    
//    private let passwordManager = PasswordManager()
//    
//    @State private var showPasswordView = false
//    @State private var chosenKey = ""
//    @State private var title = ""
//    @State private var searchText = ""
//    @State private var sortSelection = 0
//    @State private var keys: [String] = []
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    var body: some View {
//        ZStack {
//            Colors.bgColor.ignoresSafeArea()
//            VStack {
//                HStack {
//                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 20))
//                            .offset(x: -2, y: 2)
//                    }).foregroundColor(Colors.blueColor)
//                    Text("Password storage")
//                        .foregroundColor(.white)
//                        .font(.custom(FontNames.exoSemiBold, size: 22))
//                    Spacer()
//                    Button(action: {
//                        chosenKey = ""
//                        showPasswordView.toggle()
//                    }) {
//                        Image(systemName: "plus").font(.system(size: 22))
//                    }.foregroundColor(Colors.blueColor)
//                }.padding([.top, .leading, .trailing])
//                Spacer().frame(height: 18)
//                Color.white.frame(height: 1).opacity(0.08)
//                HStack {
//                    SearchBar("Search", text: $searchText)
//                        .returnKeyType(.done)
//                        .searchBarStyle(.minimal)
//                        .showsCancelButton(true)
//                        .onCancel {
//                            searchText = ""
//                        }
//                        .tintColor(Colors.blueColor)
//                        .padding(.horizontal, 12)
//                }
//                Spacer()
//                ZStack {
//                    if keys.isEmpty == false {
//                        Form {
//                            Section(header: HStack {
//                                Text("Total : \( self.keys.filter {  self.searchText.isEmpty ? true : $0.components(separatedBy: passwordManager.separator)[0].starts(with: self.searchText) }.count )").opacity(0.25).font(.custom(FontNames.exo, size: 14))
//                                Spacer()
//                                
//                                Picker(selection: $sortSelection, label: sortSelection == 0 ? Text("A-Z") : Text("Z-A"), content: {
//                                    Text("A-Z").tag(0)
//                                    Text("Z-A").tag(1)
//                                })
//                                .font(.custom(FontNames.exo, size: 14))
//                                .foregroundColor(Colors.blueColor)
//                                .pickerStyle(MenuPickerStyle())
//                            }) {
//                                List {
//                                    ForEach(sortSelection == 0 ?
//                                                self.keys.sorted().filter {
//                                                    self.searchText.isEmpty ? true : $0.lowercased().components(separatedBy: passwordManager.separator)[0].starts(with: self.searchText.lowercased()) }
//                                                :
//                                                self.keys.sorted().reversed().filter  {  self.searchText.isEmpty ? true :
//                                                    $0.lowercased().components(separatedBy: passwordManager.separator)[0].starts(with: self.searchText.lowercased()) }, id: \.self) { key in
//                                        
//                                        let keyArray = key.components(separatedBy: passwordManager.separator)
//                                        
//                                        HStack {
//                                            Button(action: {
//                                                chosenKey = key
//                                                print(chosenKey)
//                                                showPasswordView.toggle()
//                                            },
//                                            label: Text("\(keyArray[0])").font(.custom(FontNames.exo, size: 18)))
//                                        }
//                                    }
//                                }
//                            }.listRowBackground(Color.white.opacity(0.02))
//                        }.foregroundColor(.white)
//                    }
//                    
//                    VStack {}
//                        .sheet(isPresented: $showPasswordView ,content: {
//                            SavePasswordView(passwordManager: passwordManager, passwordNew: nil, isPresented: $showPasswordView, selectedKey: $chosenKey)
//                        })
//                        .navigationBarItems(trailing: Button(action:{
//                            showPasswordView.toggle()
//                            chosenKey = ""
//                        }, label: {
//                            Image(systemName: "plus")
//                        }))
//                }
//            }.onAppear() {
//                keys = passwordManager.getKeys()
//                print(keys)
//            }
//            .onChange(of: showPasswordView) { isShowing in
//                if !isShowing {
//                    print("change showPasswordView ")
//                    keys = passwordManager.getKeys()
//                    print(passwordManager.getKeys())
//                }
//            }
//        }
//    }
//}
//
//
//struct PasswordListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordListView()
//    }
//}
