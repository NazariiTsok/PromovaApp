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

public struct CategoryDetailCellView : View {
    
    let store: StoreOf<CategoryDetailCellFeature>
    
    public init(
        store: StoreOf<CategoryDetailCellFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                VStack {
                    AsyncImageView(url: URL(string: viewStore.image)!)
                        .frame(height: geometry.size.height * 0.35)
//                        .aspectRatio(contentMode: .fill)
//                        .fixedSize(horizontal: false, vertical: true)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                        .clipped()
                        .padding(10)
                    
                    HStack {
                        Text(viewStore.title)
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
            .tag(viewStore.id)
        }
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
