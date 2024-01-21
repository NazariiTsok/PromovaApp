//
//  File.swift
//
//
//  Created by Nazar Tsok on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture
import Extensions
import SharedViews

public struct CategoryDetailView: View {
    let store: StoreOf<CategoryDetailFeature>
    
    public init(store: StoreOf<CategoryDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    TabView(
                        selection: viewStore.binding(
                            get: \.currentIndex,
                            send: { .currentIndexUpdated($0) }
                        )
                    ) {
                        ForEachStore(
                            self.store.scope(
                                state: \.cells,
                                action: CategoryDetailFeature.Action.cells
                            ),
                            content: CategoryDetailCellView.init(store: )
                        )
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .overlay(alignment: .bottom) {
                        HStack(alignment : .center) {
                            Button {
                                viewStore.send(.previousItemButtonTapped, animation: .interactiveSpring)

                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .buttonStyle(BorderButtonStyle(isEnabled: viewStore.isPreviousItemEnabled))
                            
                            Spacer()
                            
                            Button {
                                viewStore.send(.nextItemButtonTapped, animation: .interactiveSpring)
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                            .buttonStyle(BorderButtonStyle(isEnabled: viewStore.isNextItemEnabled))
                        }
                        .padding([.bottom, .horizontal])
                    }
                }
                .padding(.horizontal)
                .padding(.top, 40)
                .padding(.bottom, 60)
            }
            .navigationTitle(viewStore.currentTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.main)
            .toolbarBackground(Color.main, for: .navigationBar)
        }
    }
}

#if DEBUG
struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(
            store: .init(
                initialState: CategoryDetailFeature.State(
                    category: .mock1
                ),
                reducer: { CategoryDetailFeature() }
            )
        )
    }
}
#endif



