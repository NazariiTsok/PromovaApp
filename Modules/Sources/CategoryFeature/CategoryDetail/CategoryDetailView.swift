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

extension CategoryDetailView {
    private struct ViewState: Equatable {
        let currentPageIndex: Int
        let currentPageTitle: String
        
        let isPreviousItemEnabled:Bool
        let isNextItemEnabled:Bool
        
        init(state: CategoryDetailFeature.State){
            self.currentPageIndex = state.currentPageIndex
            self.currentPageTitle = state.category.title
            self.isPreviousItemEnabled = state.currentPageIndex > 0
            self.isNextItemEnabled = state.currentPageIndex < state.pagesCount - 1
        }
    }
}

public struct CategoryDetailView: View {
    private let store: StoreOf<CategoryDetailFeature>
    
    @ObservedObject private var viewStore: ViewStore<ViewState,CategoryDetailFeature.Action>
    
    public init(store: StoreOf<CategoryDetailFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: ViewState.init, send: { $0 })
    }
    
    public var body: some View {
        ZStack {
            VStack {
                TabView(
                    selection: viewStore.binding(
                        get: \.currentPageIndex,
                        send: CategoryDetailFeature.Action.currentIndexUpdated
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
                    navigationControls
                }
            }
            .padding(.horizontal)
            .padding(.top, 40)
            .padding(.bottom, 60)
        }
        .navigationTitle(viewStore.currentPageTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.main)
        .toolbarBackground(Color.main, for: .navigationBar)
    }
}

extension CategoryDetailView {
    private var navigationControls: some View {
        HStack(alignment : .center) {
            Button {
                viewStore.send(.pageIndexButtonTapped(newPageIndex: viewStore.currentPageIndex - 1))
                
            } label: {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(BorderButtonStyle(isEnabled: viewStore.isPreviousItemEnabled))
            
            Spacer()
            
            Button {
                viewStore.send(.pageIndexButtonTapped(newPageIndex: viewStore.currentPageIndex + 1))
            } label: {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(BorderButtonStyle(isEnabled: viewStore.isNextItemEnabled))
        }
        .padding([.bottom, .horizontal])
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



