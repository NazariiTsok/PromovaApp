//
//  File.swift
//
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Models

public struct CategoryDetailFeature: Reducer {
    public struct State: Equatable, Identifiable {
        
        public var category: CategoryModel
        public var cells:IdentifiedArrayOf<CategoryDetailCellFeature.State>
        
        public var id: CategoryModel.ID {
            self.category.id
        }
        
        public var pagesCount: Int {
            self.cells.count
        }
        
        public var currentPageIndex: Int = 0
        
        public init(category: CategoryModel) {
            self.category = category
            
            self.cells = IdentifiedArray(
                uniqueElements: category.facts.enumerated().map { index, fact in
                    CategoryDetailCellFeature.State(item: fact, index: index)
                }
            )
        }
    }
    
    public enum Action: Equatable {
        case currentIndexUpdated(Int)
        case pageIndexButtonTapped(newPageIndex: Int)
        
        case cells(id: CategoryDetailCellFeature.State.ID, action: CategoryDetailCellFeature.Action)
    }
    
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let .pageIndexButtonTapped(newIndex):
                guard
                    newIndex != state.currentPageIndex,
                    newIndex >= 0,
                    newIndex < state.pagesCount
                else {
                    return .none
                }
                
                return Effect.send(.currentIndexUpdated(newIndex))
            case let .currentIndexUpdated(newIndex):
                state.currentPageIndex = newIndex
                return .none
            default :
                return .none
            }
        }
    }
}
