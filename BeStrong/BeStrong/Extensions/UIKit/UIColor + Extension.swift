import UIKit

extension UIColor {
    
    static let specialBackground = #colorLiteral(red: 0.9411764706, green: 0.9294117647, blue: 0.8862745098, alpha: 1) // F0EDE2
    static let specialGray = #colorLiteral(red: 0.3176470588, green: 0.3176470588, blue: 0.3137254902, alpha: 1) // 515150
    static let specialGreen = #colorLiteral(red: 0.2, green: 0.5529411765, blue: 0.4901960784, alpha: 1) // 338D7D
    static let specialDarkGreen = #colorLiteral(red: 0.1411764706, green: 0.2941176471, blue: 0.262745098, alpha: 1) // 244B43
    static let specialYellow = #colorLiteral(red: 0.9921568627, green: 0.8392156863, blue: 0.3568627451, alpha: 1) // FDD65B
    static let specialLightBrown = #colorLiteral(red: 0.7098039216, green: 0.6901960784, blue: 0.6196078431, alpha: 1) // B5B09E
    static let specialBrown = #colorLiteral(red: 0.9019607843, green: 0.8823529412, blue: 0.8196078431, alpha: 1) // E6E1D1
    static let specialBlack = #colorLiteral(red: 0.2156862745, green: 0.2156862745, blue: 0.2156862745, alpha: 1) // 373737
    static let specialTabBar = #colorLiteral(red: 0.8039215686, green: 0.7803921569, blue: 0.7019607843, alpha: 1) // CDC7B3
    static let specialLine = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1) // C4C4C4
    static let specialDarkYellow = #colorLiteral(red: 0.9215686275, green: 0.7058823529, blue: 0.02352941176, alpha: 1) // EBB406
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
