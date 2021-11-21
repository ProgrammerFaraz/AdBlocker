//
//  WelcomeAndDownloadFiltersView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 31.08.2021.
//

import SwiftUI
import Drops
import Purchases
import StoreKit

struct WelcomeAndDownloadFiltersView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let filters = Constants.filtersSources.filter { (filter) -> Bool in
        filter.url != ""
    }
    @State var downloaded = false
    @State var downloading = false
    @State var filter: FilterSource?
    @State var step = 0
    @State var showSheet = false
    @State var products: [Purchases.Package]?

    func mainAction() {
        let isSubscribedUser = UserDefaults.standard.bool(forKey: "isBuyed")
        if isSubscribedUser {
            BlockManager.shared.getActivationState { (value) in
                if !(value) {
                    ActiveSheet.shared.type = "hint"
                    self.showSheet = true
                } else {
                    print(BlockManager.shared.isFiltersDownloaded())
                    if !downloaded {
                        downloading = true
                        DispatchQueue.global().async {
                            for filter in self.filters {
                                DispatchQueue.main.async {
                                    withAnimation() {
                                        self.step += 1
                                        self.filter = filter
                                    }
                                }
                                let semaphore = DispatchSemaphore(value: 0)
                                filter.updateList() { error in
                                    if error == nil { semaphore.signal() } else {
                                        Drops().show(Drop(title: error?.localizedDescription ?? ""))
                                        semaphore.signal()
                                    }
                                }
                                semaphore.wait()
                                sleep(1)
                            }
                            DispatchQueue.main.async {
                                self.finishDownload()
                            }
                        }
                    } else {
                        presentationMode.dismiss()
                    }
                }
            }
        } else {
            ActiveSheet.shared.type = "purchase"
            self.showSheet = true
        }
        
    }
    
    func finishDownload() {
        downloaded = true
        downloading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            presentationMode.dismiss()
        }
    }
    
    var body: some View {
        ZStack {
            Colors.bgColor.ignoresSafeArea()
            VStack {
                HStack {
                    Text("Filter downloader and updater")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Spacer()
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reliable protection against malicious sites, tracking tools and advertising")
                        .padding()
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08), lineWidth: 2)
                        )
                    Text("Browse the Internet safely and without annoyance")
                        .padding()
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08), lineWidth: 2)
                        )
                    Text("To keep filters relevant, click on the button and download the latest versions")
                        .padding()
                        .background(Color.white.opacity(0.02))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.08), lineWidth: 2)
                        )
                    Spacer()
                    if downloading {
                        Text("Downloading filter: \(filter?.name ?? "")")
                    }
                    SegmentedProgressView(value: step, maximum: filters.count)
                        .animation(.default)
                    Button(action: {
                        self.mainAction()
                    }, label: {
                        if downloading {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            Spacer()
                        } else {
                            Text("Download filters")
                                .bold()
                                .fill(alignment: .center)
                        }
                    })
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .frame(height: 45)
                    .background(Colors.blueColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }.padding()
                
            }
            .sheet(isPresented: $showSheet) {
                if ActiveSheet.shared.type == "download" {
                    WelcomeAndDownloadFiltersView(products: self.products)
                } else if ActiveSheet.shared.type == "purchase" {
                    NewPurchaseView(products: self.products)
                } else if ActiveSheet.shared.type == "hint" {
                    HintView()
                }
            }
            .foregroundColor(.white)
        }
        .font(.system(size: 18, weight: .regular, design: .rounded))
        
    }
}

//struct WelcomeAndDownloadFiltersView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeAndDownloadFiltersView()
//    }
//}


struct SegmentedProgressView: View {
  var value: Int
  var maximum: Int = 7
  var height: CGFloat = 10
  var spacing: CGFloat = 2
  var selectedColor: Color = Colors.greenColor
  var unselectedColor: Color = Color.white.opacity(0.02)

  var body: some View {
    HStack(spacing: spacing) {
      ForEach(0 ..< maximum) { index in
        Rectangle()
          .foregroundColor(index < self.value ? self.selectedColor : self.unselectedColor)
      }
    }
    .frame(maxHeight: height)
    .clipShape(Capsule())
  }
}
