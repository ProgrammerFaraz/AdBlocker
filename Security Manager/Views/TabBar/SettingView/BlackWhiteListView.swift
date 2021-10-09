//
//  BlackWhiteListView.swift
//  Security Manager
//
//  Created by Faraz on 10/9/21.
//

import SwiftUI

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
    
    @ViewBuilder var list: some View {
        if type == .whiteList {
            NavigationView {
                List{
                    Spacer()
                        .frame(width: 2)
                    Text("add data from white list model")
                }
            }
            .navigationTitle("White List")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.viewControllerHolder?.present(style: .fullScreen) {
                            AddURLView(fromEdit: false, type: self.type)
                        }
                        print("Add tapped!")
                    }) {
                        Image("plus_icon")
                    }
                    
                    Button("Edit") {
                        self.viewControllerHolder?.present(style: .fullScreen) {
                            AddURLView(fromEdit: true, type: self.type)
                        }
                        print("Edit tapped!")
                    }
                }
            }
        }else {
            NavigationView {
                List{
                    Spacer()
                        .frame(width: 2)
                    Text("add data from black list model")
                }
            }
            .navigationTitle("Black List")
        }
    }
    var body: some View {
        list
    }
}

struct BlackWhiteListView_Previews: PreviewProvider {
    static var previews: some View {
        BlackWhiteListView(type: .whiteList)
    }
}
