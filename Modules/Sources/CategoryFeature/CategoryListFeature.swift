//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct CategoryListFeature: Reducer {
    public struct State: Equatable {
        
        public init(){
            
        }
    }
    
    public enum Action: Equatable {
        
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
    }
}
