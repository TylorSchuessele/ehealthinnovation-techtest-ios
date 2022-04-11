//
//  ehealthinnovation_techtest_iosApp.swift
//  ehealthinnovation-techtest-ios
//
//  Created by Tylor Schuessele on 2022-04-09.
//

import SwiftUI

@main
struct ehealthinnovation_techtest_iosApp: App {
    var network = Network()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
