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
import CategoryClient

extension CategoryListFeature {
    public struct Destination: Reducer {
        public enum State: Equatable {
            case detail(CategoryDetailFeature.State)
            case alert(AlertState<Action.Alert>)
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
        public var isAdvertPresented:Bool
        
        public init(
            content: ContentState<IdentifiedArrayOf<CategoryModel>, Action> = .initial,
            destination: Destination.State? = nil,
            isAdvertPresented:Bool = false
        ){
            self.content = content
            self.destination = destination
            self.isAdvertPresented = isAdvertPresented
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
        
        case navigateTo(CategoryModel)
        
        case adWatched
        case didAdWatched(CategoryModel)
    }
    
    public init(){
        
    }
    
    enum CancelID: Hashable {
        case observation
    }
    
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.categoryClient) var categoryClient
    
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
            case let .didAdWatched(category):
                state.isAdvertPresented = false
                return Effect.send(.navigateTo(category))
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
                return Effect.run { send in
                    //TODO: await for init RealmRepository,recommend doing this as early as possible in your application lifecycle,
                    // but our Category client init faster than appDelegate action
                    try await Task.sleep(for: .seconds(2))
                    
                    await send(.view(.loadCategories))
                }
            }
            return .none
        case .loadCategories:
            state.content = .loading
            
            return .merge(
                .run { send in
                    for try await categories in categoryClient.observation() {
                        await send(.view(.categoriesLoaded(.success(categories))))
                    }
                } catch: { error, send in
                    await send(.view(.categoriesLoaded(.failure(error))))
                },
                .run { _  in
                   try await categoryClient.load()
                }
            )
            .cancellable(id: CancelID.observation, cancelInFlight: true)
        case let .categoriesLoaded(.success(value)):
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
            //MARK: We can andle other errors like .failure(URLSession.Errors(....).emptyResponse)
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
        guard case let .presented(action) = action else { return .none }
        
        switch action {
        case let .alert(action):
            return handleAlertAction(action, state: &state)
        case let .detail(action):
            return handleDetailAction(action, state: &state)
        }
    }
    
    private func handleAlertAction(_ action: Destination.Action.Alert, state: inout State) -> Effect<Action> {
        switch action {
        case .showAd(let category): //MARK: Simulate Ad
            state.isAdvertPresented = true
            
            return .run { send in
                try await Task.sleep(for: .seconds(2))
                
                await send(.didAdWatched(category))
            }
        }
    }
    
    private func handleDetailAction(_ action: CategoryDetailFeature.Action, state _: inout State) -> Effect<Action> {
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
