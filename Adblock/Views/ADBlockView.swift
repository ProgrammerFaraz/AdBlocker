//
//  ADBlockView.swift
//  Security Manager
//
//  Created by Alexey Voronov on 31.08.2021.
//

import SwiftUI
import Drops

struct ADBlockView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var showingDownloadFiltersView = false
    @State var showingHintView = false
    @State var filters = Constants.filtersSources
    @State var isActivated = true
    
    var body: some View {
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
                    Text("Safari AD Block")
                        .foregroundColor(.white)
                        .font(.custom(FontNames.exoSemiBold, size: 22))
                    Spacer()
                    Button(action: {showingDownloadFiltersView = true}) {
                        Image(systemName: "arrow.clockwise")
                        Text("Update")
                    }
                }.padding([.top, .leading, .trailing])
                Spacer().frame(height: 18)
                Color.white.frame(height: 1).opacity(0.08)
                Spacer()
                ScrollView {
                    ForEach(filters, id: \.url) { filter in
                        FilterItemView(isActivated: $isActivated, filter: filter)
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                    }
                    Spacer().frame(height: 110)
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
        .onAppear() {
            if !BlockManager.shared.isFiltersDownloaded() {
                showingDownloadFiltersView = true
            }
            
            BlockManager.shared.getActivationState(completion: { result in
                    isActivated = result
            })
        }
        .onChange(of: isActivated, perform: { value in
            if !value {
                //BlockManager.shared.deactivateFilters { _ in }
            }
        })
        .sheet(isPresented: $showingDownloadFiltersView) {
            WelcomeAndDownloadFiltersView()
        }
        .sheet(isPresented: $showingHintView) {
            HintView()
        }
    }
}

struct ADBlockView_Previews: PreviewProvider {
    static var previews: some View {
        ADBlockView()
    }
}


struct FilterItemView: View {
    
    @Binding var isActivated: Bool
    @State var isShowingDestination = false
    @State var isActive = false
    
    let filter: FilterSource
    
    var body: some View {
        HStack {
            ZStack {
                Color.white.opacity(0.02)
                HStack {
                    VStack(alignment: .leading, spacing: 10){
                        HStack {
                            ZStack {
                                filter.color
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(filter.color.opacity(1.0), lineWidth: 2)
                                    )
                                    .cornerRadius(12)
                                    .opacity(0.5)
                                    .shadow(color: filter.color.opacity(0.38), radius: 30, x: 5.0, y: 3.0)
                                Image(systemName: filter.imageName)
                                    .font(.system(size: 26))
                            }
                            Toggle("", isOn: $isActive)
                        }
                        Text(filter.name)
                            .font(.custom(FontNames.exoMedium, size: 18))
                            .fixedSize(horizontal: false, vertical: true)
                        Text(filter.version)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .font(.custom(FontNames.exo, size: 12))
                            .opacity(0.3)
                        HStack {
                            Text(filter.description)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .font(.custom(FontNames.exo, size: 14))
                                .opacity(0.5)
                            Spacer()
                        }
                        .maxWidth(250)
                    }
                    .padding()
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.08), lineWidth: 2)
            )
            .cornerRadius(20.0)
        }
        .onAppear() {
            if isActivated {
                isActive = filter.activate
            } else {
                isActive = false
            }
        }
        .onChange(of: isActive, perform: { value in
            if value != filter.activate {
                isActivated = false
                filter.activate = value
            }
        })
    }
}
