//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture
import Extensions

public struct CategoryDetailView: View {
    let store: StoreOf<CategoryDetailFeature>
    
    public init(store: StoreOf<CategoryDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                //PAging for facts elements
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
