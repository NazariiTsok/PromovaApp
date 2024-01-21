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
    public struct State: Equatable {
        
        public var category: CategoryModel
        
        public var currentTitle: String
        public var currentIndex: Int
        public var currentItems: [FactModel]
        
        public var selectedItem: FactModel?
        public var focusedItem: FactModel?
        
        public init(
            category: CategoryModel
        ) {
            self.category = category
            self.currentTitle = category.title
            
            self.currentItems = category.facts
            self.currentIndex = category.facts.startIndex
            
        }
        
        var isPreviousItemEnabled:Bool {
            self.currentIndex > 0
        }
        
        var isNextItemEnabled:Bool {
            self.currentIndex < self.currentItems.count - 1
        }
    }
    
    public enum Action: Equatable {
        case nextItemButtonTapped
        case previousItemButtonTapped
        
        case currentIndexUpdated(Int)
        case currentItemsUpdated([FactModel])
        case selectedItemUpdated(FactModel)
        case focusedItemUpdated(FactModel)
    }
    
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .nextItemButtonTapped, .previousItemButtonTapped:
                return handleItemNavigation(action, state: &state)
            case .currentIndexUpdated(let newIndex):
                state.currentIndex = newIndex
                return .none
            case .currentItemsUpdated(let newItems):
                state.currentItems = newItems
                return .none
            case .selectedItemUpdated(let newSelectedItem):
                state.selectedItem = newSelectedItem
                return .none
            case .focusedItemUpdated(let newFocusedItem):
                state.focusedItem = newFocusedItem
                return .none
            }
        }
    }
    
    private func handleItemNavigation(_ action: Action, state: inout State) -> Effect<Action> {
        switch action {
        case .previousItemButtonTapped:
            if state.isPreviousItemEnabled {
                state.currentIndex -= 1
            }
            return .none
        case .nextItemButtonTapped:
            if state.isNextItemEnabled {
                state.currentIndex += 1
            }
            return .none
        default :
            return .none
        }
    }
}
