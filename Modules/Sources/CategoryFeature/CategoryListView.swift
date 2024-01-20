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

public struct CategoryListView: View {
    let store: StoreOf<CategoryListFeature>
    
    public init(store: StoreOf<CategoryListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
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
            .onAppear {
                viewStore.send(.view(.onAppear))
            }
        }
    }
    
    @ViewBuilder
    private func categoriesList(with categories: IdentifiedArrayOf<CategoryModel>) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(categories, id: \.id) { category in
                    Text(category.title)
                }
            }
            .padding(.all)
            
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
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
        //TODO: We can show mock list with placeholder shimmering effects when load data

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
