//
//  File.swift
//
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import SharedViews
import Models

extension CategoryDetailCellView {
    private struct ViewState: Equatable {
        let itemImageUrl: String
        let itemTitle: String
        let itemId: Int
        
        init(state: CategoryDetailCellFeature.State){
            self.itemImageUrl = state.item.image
            self.itemTitle = state.item.fact
            self.itemId = state.id
        }
    }
}

public struct CategoryDetailCellView : View {
    
    let store: StoreOf<CategoryDetailCellFeature>
    
    @ObservedObject private var viewStore: ViewStore<ViewState,CategoryDetailCellFeature.Action>
    
    public init(
        store: StoreOf<CategoryDetailCellFeature>
    ) {
        self.store = store
        self.viewStore = ViewStore(store, observe: ViewState.init, send: { $0 })
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                AsyncImageView(url: viewStore.itemImageUrl)
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width - 20,
                        height: geometry.size.height * 0.35
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .clipped()
                    .padding(.vertical)
                
                HStack {
                    Text(viewStore.itemTitle)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height * 0.65,
                alignment : .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .tag(viewStore.itemId)
    }
}

#if DEBUG
struct CategoryDetailCellView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailCellView(
            store: .init(
                initialState: CategoryDetailCellFeature.State(
                    item: FactModel.mock[1],
                    index: 1
                ),
                reducer: { CategoryDetailCellFeature() }
            )
        )
    }
}
#endif
