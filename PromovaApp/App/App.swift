//
//  PromovaAppApp.swift
//  PromovaApp
//
//  Created by Nazar Tsok on 20.01.2024.
//

import SwiftUI
import ComposableArchitecture
import AppFeature

@main
struct PromovaAppApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: AppFeature.State(),
                    reducer: { AppFeature() }
                )
            )
        }
    }
}
