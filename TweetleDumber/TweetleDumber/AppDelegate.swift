//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class AppDelegate: ServicesApplicationDelegate {
    private(set) var window: UIWindow?
    
    override init() {
        super.init(services: [DependenciesApplicationService()])
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.window = RootWindow()
        return result
    }
}
