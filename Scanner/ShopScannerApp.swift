//
//  ShopScannerApp.swift
//  ShopScanner
//
//  Created by Arsen on 02.02.2023.
//

import SwiftUI
import FirebaseCore

// главная структура приложения
@main
struct ShopScannerApp: App {
    
    @ObservedObject private var vm = AppViewModel()
    
    var body: some Scene {
        // окно приложения
        WindowGroup {
            ContentViewScanner()
                .background(.black)
                .environmentObject(vm)
                .task {
                    FirebaseApp.configure()
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}


