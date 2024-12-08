//
//  test_shau_2App.swift
//  test-shau-2
//
//  Created by Shaunak Umarkhedi on 07/11/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct test_shau_2App: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
