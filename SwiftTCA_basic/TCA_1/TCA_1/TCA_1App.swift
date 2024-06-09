//
//  TCA_1App.swift
//  TCA_1
//
//  Created by 성재 on 6/9/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: RanAni.State()) {
                    RanAni()
                }
            )
        }
    }
}
