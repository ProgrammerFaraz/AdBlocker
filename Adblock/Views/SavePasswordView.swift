//
//  SavePasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI
import SwiftUIX
import KeychainSwift
import Drops

struct SavePasswordView: View {
    
    let passwordManager: PasswordManager
    let passwordNew: String?
    
    @Binding var isPresented: Bool
    var selectedKey: Binding<String>?
    
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var title: String = ""
    @State private var showKeyboard = false
    @State private var showMissingTitleAlert = false
    @State private var showMissingPasswordAlert = false
    @State private var showMissingPasswordAndTitleAlert = false
    @State private var showMissingUsernameFooter = false
    @State private var showMissingTitleFooter = false
    @State private var oldKey = ""
    @State private var passHidden = true
    @State private var viewTitle = ""
    
    let keyboard = Keyboard()
    let keychain = KeychainSwift()
    let passManager = PasswordManager()
    
    func saveAction() {
        if title.isEmpty || password.isEmpty {
            showMissingPasswordAndTitleAlert.toggle()
            print("Missing fields")
        }
        
        else if !title.isEmpty && !password.isEmpty {
            isPresented.toggle()
            
            passManager.deletePassword(key: oldKey)
            
            let newPass = PasswordItemModel(title: title, username: username, password: password, passManager: passManager)
            
            newPass.saveToKeychain()
            
            Drops.show(Drop(title: "Password saved successfully"))
        }
        
        print("on save \(passManager.getKeys())")
    }
    
    func loadPasswordItem() {
        let passwordItem = PasswordItemModel(key: selectedKey?.wrappedValue ?? "", passManager: passManager)
        passwordItem.loadFromKeychain()
        
        oldKey = passwordItem.key
        password = passwordNew ?? passwordItem.password
        title = passwordItem.title
        username = passwordItem.username
    }
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Text(viewTitle)
                        .foregroundColor(.white)
                        .font(.custom(FontNames.exoSemiBold, size: 22))
                    Spacer()
                    Button(action: { isPresented.toggle() }) {
                        Image(systemName: "xmark").font(.system(size: 22))
                    }.foregroundColor(Colors.blueColor)
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                Form {
                    Section(header: Text("Password").foregroundColor(.gray).font(.custom(FontNames.exo, size: 14)),
                            footer: password.isEmpty ? Text("Required Field").foregroundColor(Colors.orangeColor).font(.custom(FontNames.exo, size: 14)) : Text("")) {
                        HStack {
                            if passHidden {
                                SecureField("password", text: $password)
                            } else {
                                TextField("password", text: $password)
                            }
                            Button(action: { passHidden.toggle() }, label: {
                                Image(systemName: (passHidden ? "eye.slash.fill" : "eye.fill")).foregroundColor(Colors.blueColor)
                            })
                            .rotationEffect(Angle.degrees(passHidden ? 180 : 0))
                            .animation(.easeInOut(duration: 0.2))
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.02))
                    .font(.custom(FontNames.exo, size: 18))
                    
                    Section(header: Text("Username").foregroundColor(.gray).font(.custom(FontNames.exo, size: 14))) {
                        TextField("example@icloud.com", text: $username)
                        
                    }.listRowBackground(Color.white.opacity(0.02))
                    .font(.custom(FontNames.exo, size: 18))
                    
                    Section(header: Text("Title").foregroundColor(.gray).font(.custom(FontNames.exo, size: 14)), footer: title.isEmpty ? Text("Required Field").foregroundColor(Colors.orangeColor).font(.custom(FontNames.exo, size: 14)) : Text("") ) {
                        TextField("Twitter", text: $title)
                        
                    }.listRowBackground(Color.white.opacity(0.02))
                    .alert(isPresented: $showMissingTitleAlert, content: {
                        Alert(title: Text("Warning"), message: Text("Missing title"), dismissButton: .cancel(Text("OK")))
                        
                    })
                    .font(.custom(FontNames.exo, size: 18))
                    
                    Button(action: {self.saveAction()}, label: {
                        Text("Save")
                            .bold()
                            .fill(alignment: .center)
                    })
                    .font(.custom(FontNames.exo, size: 18))
                    .listRowBackground(Colors.blueColor)
                }
                .foregroundColor(.white)
                .alert(isPresented: $showMissingPasswordAndTitleAlert, content: {
                    Alert(title: Text("Warning"), message: Text("missing title and password"), dismissButton: .cancel(Text("OK")))
                })
            }
            .onAppear(perform: {
                loadPasswordItem()
                
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = UIColor.clear
                
                viewTitle = username.isEmpty ? "Save Password" : "Edit Password"
            })
        }
    }
}

struct SavePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordView(passwordManager: PasswordManager(), passwordNew: nil, isPresented: .constant(true), selectedKey: .constant(PasswordManager().getKeys().first!))
            .preferredColorScheme(.dark)
    }
}
