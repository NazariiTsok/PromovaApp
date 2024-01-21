//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture

public struct CategoryDetailView: View {
    let store: StoreOf<CategoryDetailFeature>
    
    public init(store: StoreOf<CategoryDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("CategoryDetailFeature")
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
