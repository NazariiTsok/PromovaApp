//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import CategoryFeature

public struct AppFeature: Reducer {
    public struct State: Equatable {
        public var appDelegate: AppDelegateFeature.State
        public var categoryList: CategoryListFeature.State
        
        public init(
            appDelegate: AppDelegateFeature.State = .init(),
            categoryList: CategoryListFeature.State = .init()
        ) {
            self.appDelegate = appDelegate
            self.categoryList = categoryList
        }
    }
    
    public enum Action: Equatable {
        case categoryList(CategoryListFeature.Action)
        case appDelegate(AppDelegateFeature.Action)
    }
    
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            default :
                return .none
            }
        }
        
        Scope(state: \.categoryList, action: /Action.categoryList) {
            CategoryListFeature()
        }
        
        Scope(state: \.appDelegate, action: /Action.appDelegate) {
            AppDelegateFeature()
        }
    }
}
