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
            case detail(CategoryDetailFeature.State)
            case alert(AlertState<Action.Alert>)
        
            //Add DetailFeature for navigation destination push
        }
        
        public enum Action: Equatable {
            case detail(CategoryDetailFeature.Action)
            case alert(Alert)
            
            public enum Alert: Equatable {
                case showAd(CategoryModel)
            }
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: /State.detail, action: /Action.detail) {
                CategoryDetailFeature()
            }
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
            
            case onCategoryTapped(CategoryModel)
            
            case loadCategories
            case categoriesLoaded(TaskResult<[CategoryModel]>)
        }
        
        //Navigation Actions
        
        case navigateTo(CategoryModel)
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
            case let .navigateTo(category):
                state.destination = .detail(CategoryDetailFeature.State(category: category))
                return .none
            default :
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
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
        case let .onCategoryTapped(category):
            switch category.status {
            case .free :
                return Effect.send(.navigateTo(category))
            case .paid :
                state.destination = .alert(.adRequest(for: category))
            case .comingSoon :
                state.destination = .alert(.comingSoon(for: category))
            }
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

extension AlertState where Action == CategoryListFeature.Destination.Action.Alert {
    static func adRequest(for category: CategoryModel) -> Self {
        Self {
            TextState("Premium Access Required")
        } actions: {
            
            ButtonState(action: .showAd(category)) {
                TextState("Show Ad")
            }
            
            ButtonState(role: .cancel) {
                TextState("Cancel")
            }
        } message: {
            TextState("Watch an Ad to continue.")
        }
    }
    
    static func comingSoon(for category: CategoryModel) -> Self {
        Self {
            TextState("Coming Soon")
        } actions: {
            ButtonState(role: .cancel) {
                TextState("Ok")
            }
        } message: {
            TextState("Stay Tuned: \(category.title) Will Be Available Shortly")
        }
    }
}
