//
//  AppIconFeatureView.swift
//  Lemming
//
//  Created by Luca Kaufmann on 30.6.2023.
//

import SwiftUI
import ComposableArchitecture

struct AppIconFeatureView: View {

    let store: StoreOf<AppIconFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                List {
                    ForEach(viewStore.icons) { appIcon in
                        HStack(spacing: 16) {
                            Image(uiImage: appIcon.preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                            Text(appIcon.description)
                                .font(.title3)
                            Spacer()
                            CheckboxView(isSelected: viewStore.currentIcon == appIcon)
                                .frame(width: 25, height: 25, alignment: .center)
                        }
                        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        .cornerRadius(20)
                        .onTapGesture {
                            viewStore.send(.didSelectIcon(appIcon))
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .navigationTitle("App Icons")
                .background {
                    #if os(xrOS)
                    Color
                        .LemmingColors
                        .background
                        .opacity(0.5)
                        .ignoresSafeArea()
                    #else
                    Color
                        .LemmingColors
                        .background
                        .ignoresSafeArea()
                    #endif
                }
        }
    }
}

struct AppIconFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconFeatureView(store: Store(initialState: .init(currentIcon: .standard, icons: AppIcon.allCases), reducer: AppIconFeature()))
    }
}

struct CheckboxView: View {
    let isSelected: Bool
    private var imageName: String {
        return isSelected ? "checkmark.square.fill" : "square"
    }

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .foregroundColor(Color.LemmingColors.primary)
    }
}
