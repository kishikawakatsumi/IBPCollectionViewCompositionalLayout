import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let window = UIWindow()
        let navigationController = UINavigationController(rootViewController: TopViewController())
        navigationController.navigationBar.tintColor = .black
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
