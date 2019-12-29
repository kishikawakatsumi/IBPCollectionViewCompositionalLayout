import UIKit

extension UIColor {
    static var systemBackground: UIColor {
        let lightColor = UIColor.white
        let darkColor = UIColor.black
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        }
        return lightColor
    }
    static var placeholderText: UIColor {
        let lightColor = UIColor(red: 235/255, green: 235/255, blue: 245/255, alpha: 0.3)
        let darkColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        }
        return lightColor
    }
    static var systemGray2: UIColor {
        let lightColor = UIColor(red: 174/255, green: 174/255, blue: 178/255, alpha: 1)
        let darkColor = UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
        if #available(iOS 13.0, *) {
            return UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        }
        return lightColor
    }
}

extension UIImage {
    convenience init?(systemName: String) {
        self.init(named: systemName)
    }
}
