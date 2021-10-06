//
//  AppDelegate.swift
//  Repositories
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main",
                                                    bundle: nil)
        if let mainVc = storyboard.instantiateInitialViewController() as? MainViewController {
            let mainRouter: MainRouter = .init(viewController: mainVc)
            mainVc.viewModel = MainViewModel(router: mainRouter)
            window?.rootViewController = UINavigationController(rootViewController: mainVc)
            window?.makeKeyAndVisible()
        }
        return true
    }
    
}

