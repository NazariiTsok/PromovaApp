//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import APIClient
import Models
import SharedViews

extension CategoryListFeature {
    public struct Destination: Reducer {
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            
            //Add DetailFeature for navigation destination push
        }
        
        public enum Action: Equatable {
            case alert(Alert)
            
            public enum Alert: Equatable {
                case showAd(CategoryModel)
            }
        }
        
        public var body: some ReducerOf<Self> {
            EmptyReducer()
        }
    }
}

public struct CategoryListFeature: Reducer {
    public struct State: Equatable {
        
        @PresentationState public var destination: Destination.State?
        
        public var content: ContentState<IdentifiedArrayOf<CategoryModel>, Action>
        
        public init(
            content: ContentState<IdentifiedArrayOf<CategoryModel>, Action> = .initial,
            destination: Destination.State? = nil
        ){
            self.content = content
            self.destination = destination
        }
    }
    
    public enum Action: Equatable {
        case view(ViewAction)
        case destination(PresentationAction<Destination.Action>)
        
        public enum ViewAction: Equatable {
            case onAppear
            case loadCategories
            case categoriesLoaded(TaskResult<[CategoryModel]>)
        }
    }
    
    public init(){
        
    }

    @Dependency(\.apiClient) var apiClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case let.view(action):
                return handleViewAction(action, state: &state)
            case let .destination(action):
                return handleDestinationAction(action, state: &state)
            default :
                return .none
            }
        }
    }
    
    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            if state.content == .initial {
                return Effect.send(.view(.loadCategories))
            }
            return .none
        case .loadCategories:
            state.content = .loading
            
            return .run { send in
                await send(.view(.categoriesLoaded(TaskResult {
                    try await apiClient.fetchCategories()
                })))
            }
        case let .categoriesLoaded(.success(value)):
            // Early exit if no categories are loaded
            guard !value.isEmpty else {
                state.content = .initial
                return .none
            }
            
            let sortedCategories = IdentifiedArray(
                uniqueElements: value.sorted { $0.order < $1.order }
            )
            
            state.content = .loaded(sortedCategories)
            return .none
        case let .categoriesLoaded(.failure(error)):
            state.content = .error(.serverError(.init(error: error)))
            return .none
        default :
            return .none
        }
    }
    
    private func handleDestinationAction(_ action: PresentationAction<Destination.Action>, state: inout State) -> Effect<Action> {
        return .none
    }
    
    private func handleAlertAction(_ action: Destination.Action.Alert, state: inout State) -> Effect<Action> {
        return .none
    }
}

public extension ErrorState {
    static func serverError(_ error: Error) -> ErrorState<CategoryListFeature.Action> {
        .init(
            title: "Cannot Load Categories",
            body: "There was an error loading your recent categories.",
            error: .init(error: error),
            action: .init(label: "Retry", action: .view(.loadCategories))
        )
    }
}
