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
        
        public var id: CategoryModel.ID
        
        public var currentTitle: String
        public var currentIndex: Int = 0
        
        public var cells:IdentifiedArrayOf<CategoryDetailCellFeature.State>
        
        public init(
            category: CategoryModel
        ) {
            self.id = category.id
            self.currentTitle = category.title
            
            self.cells = IdentifiedArray(
                uniqueElements: category.facts.enumerated().map { index, fact in
                    CategoryDetailCellFeature.State(item: fact, index: index)
                }
            )
        }
        
        public var isPreviousItemEnabled:Bool {
            self.currentIndex > 0
        }
        
        public var isNextItemEnabled:Bool {
            self.currentIndex < self.cells.count - 1
        }
    }
    
    public enum Action: Equatable {
        case currentIndexUpdated(Int)
        
        case nextItemButtonTapped
        case previousItemButtonTapped
        
        case cells(id: CategoryDetailCellFeature.State.ID, action: CategoryDetailCellFeature.Action)
    }
    
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .nextItemButtonTapped:
                if state.isNextItemEnabled {
                    state.currentIndex += 1
                }
                return .none
            case .previousItemButtonTapped:
                if state.isPreviousItemEnabled {
                    state.currentIndex -= 1
                }
                return .none
            case let .currentIndexUpdated(newIndex):
                state.currentIndex = newIndex
                print("CurrentIndex : \(state.currentIndex)")
                return .none
            default :
                return .none
            }
        }
    }
}
