//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import SwiftUI
import ComposableArchitecture
import CategoryFeature

public struct AppView: View {
    let store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            CategoryListView(
                store: self.store.scope(
                    state: \.categoryList,
                    action: AppFeature.Action.categoryList
                )
            )
        }
        .tint(.black)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: .init(
                initialState: AppFeature.State(),
                reducer: { AppFeature() }
            )
        )
    }
}
