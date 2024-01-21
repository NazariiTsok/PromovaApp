//
//  PromovaAppApp.swift
//  PromovaApp
//
//  Created by Nazar Tsok on 20.01.2024.
//

import SwiftUI
import ComposableArchitecture
import AppFeature
import RealmRepository

@main
struct PromovaAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppView(store: self.appDelegate.store)
        }
    }
}
