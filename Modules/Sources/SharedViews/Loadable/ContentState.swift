//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation

//MARK: Wrapper type to represent the state of a loadable object. Typically from a network request

public enum ContentState<T: Equatable, Action>: Equatable {
    
    case initial
    case loading
    case loaded(T)
    case error(ErrorState<Action>)
    
    public var elements: T? {
        switch self {
        case let .loaded(results):
            return results
        default:
            return nil
        }
    }
}

public struct EmptyState: Equatable {
    public let text: String
    public var message: NSAttributedString?
    
    public init(
        text: String,
        message: NSAttributedString? = nil
    ) {
        self.text = text
        self.message = message
    }
}

public struct ErrorState<A>: Equatable {
    public var systemImageName: String?
    public let title: String
    public var body: String?
    public var error: Error?
    public var action: Action?
    
    public init(
        systemImageName: String? = nil,
        title: String,
        body: String? = nil,
        error: Error? = nil,
        action: Action? = nil
    ) {
        self.systemImageName = systemImageName
        self.title = title
        self.body = body
        self.error = error
        self.action = action
    }
    
    public struct Action: Equatable {
        public let label: String
        public var action: A
        
        public init(label: String, action: A) {
            self.label = label
            self.action = action
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.label == rhs.label
        }
    }
}

public extension ErrorState {
    struct Error: Equatable, LocalizedError {
        public let errorDump: String
        public let message: String
        
        public init(error: Swift.Error) {
            var string = ""
            dump(error, to: &string)
            self.errorDump = string
            self.message = error.localizedDescription
        }
        
        public var errorDescription: String? {
            message
        }
    }
}
