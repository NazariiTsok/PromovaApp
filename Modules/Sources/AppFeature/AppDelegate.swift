//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI

public struct AppDelegateFeature: Reducer {
    
    public struct State: Equatable {
        public init() {}
      }
    
    public enum Action: Equatable {
        case didFinishLaunching
        
        case willResignActive
        case willEnterForeground(_ application: UIApplication)
        case didEnterBackground(_ application: UIApplication)
        case didBecomeActive
        
        case didRegisterForRemoteNotifications(Result<Data, NSError>)
        case didChangeScenePhase(ScenePhase)
    }
    
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .didFinishLaunching:
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                           //TODO: Call RealmWrapepr client to sync with database
                        }
                    }
                }
            default :
                return .none
            }
        }
    }
}
