////
////  PasswordView.swift
////  PasswordGenerator
////
////  Created by Iliane Zedadra on 06/05/2021.
////
//
//import SwiftUI
//import SwiftUIX
//import MobileCoreServices
//import LocalAuthentication
//
//struct PasswordGeneratorView: View {
//    init() {
//        UITableView.appearance().backgroundColor = .clear
//        UITableViewCell.appearance().backgroundColor = UIColor.clear
//    }
//    
//    private let passwordManager = PasswordManager()
//    
//    @State private var uppercased = true
//    @State private var withNumbers = true
//    @State private var specialCharacters = true
//    @State private var numberOfCharacter = 20.0
//    
//    @State private var generatedPassword = ""
//    @State private var savePasswordSheetIsPresented = false
//    
//    @State private var characters = [String]()
//    @State private var clipboardSaveAnimation = false
//    @State private var currentPasswordEntropy = 0.0
//    
//    let passwordGenerator = PasswordGenerator()
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
//                    Text("Password generator")
//                        .foregroundColor(.white)
//                        .font(.custom(FontNames.exoSemiBold, size: 22))
//                    Spacer()
//                }.padding([.top, .leading, .trailing])
//                Spacer().frame(height: 18)
//                Color.white.frame(height: 1).opacity(0.08)
//                Form {
//                    Section(header: Text("Randomly generated password").opacity(0.25).font(.custom(FontNames.exo, size: 14)),
//                            footer:
//                                VStack {
//                                    HStack {
//                                        Spacer()
//                                        PasswordStrenghtView(entropy: currentPasswordEntropy)
//                                        Spacer()
//                                    }
//                    }) {
//                        HStack {
//                            Spacer()
//                            HStack(spacing: 0.5) {
//                                ForEach(characters, id: \.self) { character in
//                                    Text(character).foregroundColor(passwordGenerator.specialCharactersArray.contains(character) ? Colors.pinkColor : passwordGenerator.numbersArray.contains(character) ? Colors.greenColor : passwordGenerator.alphabet.contains(character) ? Colors.grayColor : Colors.orangeColor)
//                                }
//                            }
//                            .font(numberOfCharacter > 25 ? .custom(FontNames.exo, size: 15) : .custom(FontNames.exo, size: 18))
//                            .animation(.easeOut(duration: 0.1))
//                            Spacer()
//                            Button(action: {
//                                UIPasteboard.general.string = generatedPassword
//                            }, label: {
//                                Image(systemName: "doc.on.doc")
//                                    .foregroundColor(Colors.blueColor)
//                            }).buttonStyle(PlainButtonStyle())
//                        }
//                        HStack {
//                            Spacer()
//                            Button(action: { savePasswordSheetIsPresented.toggle()}, label: {
//                                Text("Add to storage")
//                                    .font(.custom(FontNames.exo, size: 18))
//                                    .foregroundColor(Colors.blueColor)
//                            }).buttonStyle(PlainButtonStyle())
//                            Spacer()
//                        }
//                    }
//                    .listRowBackground(Color.white.opacity(0.02))
//                    
//                    
//                    Section(header: Text("Character count").opacity(0.25).font(.custom(FontNames.exo, size: 14))) {
//                        HStack {
//                            Slider(value: $numberOfCharacter, in: passwordGenerator.passwordLenghtRange, step: 1)
//                                .accentColor(Colors.blueColor)
//                            Divider().frame(minWidth: 20)
//                            Text("\(Int(numberOfCharacter))")
//                                .frame(minWidth: 25)
//                                .font(.custom(FontNames.exo, size: 18))
//                        }
//                        Button(action: {
//                            characters = passwordGenerator.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
//                            generatedPassword = characters.joined()
//                            currentPasswordEntropy = passwordGenerator.calculatePasswordEntropy(password: characters.joined())
//                        },
//                        label: {
//                            HStack {
//                                Spacer()
//                                Text("Generate")
//                                    .font(.custom(FontNames.exo, size: 18))
//                                Image(systemName: "arrow.clockwise")
//                                Spacer()
//                            }
//                        })
//                        .foregroundColor(Colors.blueColor)
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                    .listRowBackground(Color.white.opacity(0.02))
//                    Section(header: Text("Include").opacity(0.25).font(.custom(FontNames.exo, size: 14)), footer: Text("Note: each active parameter reinforces the password security.").padding().opacity(0.25).font(.custom(FontNames.exo, size: 14))) {
//                        Toggle(isOn: $specialCharacters, label: {
//                            HStack {
//                                Text("Special characters")
//                                Text("&-$").foregroundColor(Colors.pinkColor)
//                            }
//                        })
//                        .toggleStyle(SwitchToggleStyle(tint: Colors.blueColor))
//                        Toggle(isOn: $uppercased, label: {
//                            HStack {
//                                Text("Uppercase")
//                                Text("A-Z").foregroundColor(Colors.orangeColor)
//                            }
//                        })
//                        .toggleStyle(SwitchToggleStyle(tint: Colors.blueColor))
//                        Toggle(isOn: $withNumbers, label: {
//                            HStack {
//                                Text("Numbers")
//                                Text("0-9").foregroundColor(Colors.greenColor)
//                            }
//                        })
//                        .toggleStyle(SwitchToggleStyle(tint: Colors.blueColor))
//                    }
//                    .font(.custom(FontNames.exo, size: 18))
//                    .listRowBackground(Color.white.opacity(0.02))
//                }
//                .foregroundColor(.white)
//            }
//        }.sheet(isPresented: $savePasswordSheetIsPresented ,  content: {
//            SavePasswordView(passwordManager: passwordManager, passwordNew: generatedPassword, isPresented: $savePasswordSheetIsPresented)
//        })
//        .onChange(of: numberOfCharacter, perform: { _ in
//            characters = passwordGenerator.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
//            generatedPassword = characters.joined()
//            currentPasswordEntropy = passwordGenerator.calculatePasswordEntropy(password: characters.joined())
//        })
//        .onChange(of: uppercased, perform: { _ in
//            characters = passwordGenerator.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
//            generatedPassword = characters.joined()
//            currentPasswordEntropy = passwordGenerator.calculatePasswordEntropy(password: characters.joined())
//        })
//        .onChange(of: specialCharacters, perform: { _ in
//            characters = passwordGenerator.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
//            generatedPassword = characters.joined()
//            currentPasswordEntropy = passwordGenerator.calculatePasswordEntropy(password: characters.joined())
//        })
//        .onChange(of: withNumbers, perform: { _ in
//            characters = passwordGenerator.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
//            generatedPassword = characters.joined()
//            currentPasswordEntropy = passwordGenerator.calculatePasswordEntropy(password: characters.joined())
//        })
//        .onAppear(perform: {
//            characters = passwordGenerator.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
//            generatedPassword = characters.joined()
//            currentPasswordEntropy = passwordGenerator.calculatePasswordEntropy(password: characters.joined())
//            
//        })
//    }
//}
//
//
//
//struct PasswordGeneratorView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordGeneratorView()
//    }
//}
//
