//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct CategoryListView: View {
    let store: StoreOf<CategoryListFeature>
    
    public init(store: StoreOf<CategoryListFeature>) {
        self.store = store
    }
    
    public var body: some View {
       Text("CategoryListFeature!!!")
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