//
//  File.swift
//
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Models
import SharedViews
import Extensions

extension CategoryListView {
    private struct ViewState: Equatable {
        
        var content: ContentState<IdentifiedArrayOf<CategoryModel>, CategoryListFeature.Action>
        var isAdvertPresented:Bool
        
        init(state: CategoryListFeature.State){
            self.content = state.content
            self.isAdvertPresented = state.isAdvertPresented
        }
    }
}

public struct CategoryListView: View {
    let store: StoreOf<CategoryListFeature>
    
    @ObservedObject private var viewStore: ViewStore<ViewState, CategoryListFeature.Action>
    
    public init(store: StoreOf<CategoryListFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: ViewState.init, send: { $0 })
    }
    
    public var body: some View {
        ZStack {
            switch viewStore.content {
            case .initial:
                initialStateView()
            case .loading:
                progressView()
            case let .loaded(categories):
                categoriesList(with: categories)
            case let .error(errorState):
                errorStateView(errorState)
            }
        }
        .alert(
            store: self.store.scope(
                state: \.$destination,
                action: CategoryListFeature.Action.destination
            ),
            state: /CategoryListFeature.Destination.State.alert,
            action: CategoryListFeature.Destination.Action.alert
        )
        .navigationDestination(
            store: self.store.scope(
                state: \.$destination,
                action: CategoryListFeature.Action.destination
            ),
            state: /CategoryListFeature.Destination.State.detail,
            action: CategoryListFeature.Destination.Action.detail,
            destination: CategoryDetailView.init
        )
        .fullScreenCover(
            isPresented: viewStore.binding(
                get: \.isAdvertPresented,
                send: .adWatched
            )
        ) {
            ProgressView()
        }
        .onAppear {
            viewStore.send(.view(.onAppear))
        }
    }
    
    @ViewBuilder
    private func categoriesList(with categories: IdentifiedArrayOf<CategoryModel>) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(categories, id: \.id) { category in
                    CategoryRowView(category: category)
                        .onTapGesture {
                            viewStore.send(.view(.onCategoryTapped(category)))
                        }
                }
            }
            .padding(.all)
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.main)
        .toolbarBackground(Color.main, for: .navigationBar)
    }
    
    @ViewBuilder
    private func errorStateView(_ errorState: ErrorState<CategoryListFeature.Action>) -> some View {
        VStack(spacing : 8) {
            
            Text(errorState.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            
            if let body = errorState.body {
                Text(body)
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .padding(.horizontal, 30)
                    .foregroundColor(.secondary)
            }
            
            if let action = errorState.action {
                Button(
                    action: { store.send(action.action) }
                ) {
                    Text(action.label)
                        .font(.body)
                        .fontWeight(.bold)
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)
                .padding(.top, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(UIColor.systemBackground))
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private func progressView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .black))
            .controlSize(.regular)
    }
    
    @ViewBuilder
    private func initialStateView() -> some View {
        //MARK: Initial state view when categories is empty 
        
        EmptyView()
    }
}

#if DEBUG
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(
            store: .init(
                initialState: CategoryListFeature.State(),
                reducer: { CategoryListFeature() }
            )
        )
    }
}
#endif
