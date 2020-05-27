//
//  AppDelegate.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 12.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit
import MathpixClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    // MARK: - Properties

    var window: UIWindow?
    var coordinator: MainCoordinator!
    
    
    // MARK: - Lifecycle

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupServices()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        coordinator = InitialScreenSetter(window: window).setup()
        coordinator.start()
        return true
    }
    
    
    private func setupServices() {
        MathpixClient.setApiKeys(appId: "arthur_ponomar_gmail_com",
                                 appKey: "2b4fa7b7db3ebfee5b70")
        DataService.shared.fetchData()
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        DataService.shared.commitChanges()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataService.shared.commitChanges()
    }
}

