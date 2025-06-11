//
//  Extensions.swift
//  SixtemiaTest
//
//  Created by lluisborras on 18/9/18.
//  Copyright © 2018 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit
import AudioToolbox

// MARK: - EXTENSION - UILabel
extension UILabel {
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(kCTUnderlineStyleAttributeName as NSAttributedString.Key, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    func notUnderline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(kCTUnderlineStyleAttributeName as NSAttributedString.Key, value: [], range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
}

// MARK: - EXTENSION - UIApplication
extension UIApplication {
    
    var topMostViewController: UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    var topMostNavigationController: UINavigationController? {
        return topMostViewController as? UINavigationController
    }
    
    /// App has more than one window and just want to get topMostViewController of the AppDelegate window.
    var appDelegateWindowTopMostViewController: UIViewController? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        var topController = delegate?.window?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    func setStatusBar(style: UIStatusBarStyle) {
        if style == .lightContent {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            if #available(iOS 13, *) {
                UIApplication.shared.statusBarStyle = .darkContent
            } else {
                UIApplication.shared.statusBarStyle = .default
            }
        }
    }
}



// MARK: - EXTENSION - UIViewController
extension UIViewController {
    
    func showToast(message : String) {
        
        for v in self.view.subviews{
            if v.tag == 998 {
                v.removeFromSuperview()
            }
        }
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.systemFont(ofSize: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.tag = 998
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

// MARK: - EXTENSION - UINavigationController
extension UINavigationController {
    
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs[vcs.count - 1] = viewController
        setViewControllers(vcs, animated: animated)
    }
    
    func hairLine(hide: Bool) {
        //hides hairline at the bottom of the navigationbar
        for subview in self.navigationBar.subviews {
            if subview.isKind(of: UIImageView.self) {
                for hairline in subview.subviews {
                    if hairline.isKind(of: UIImageView.self) && hairline.bounds.height <= 1.0 {
                        hairline.isHidden = hide
                    }
                }
            }
        }
        
    }
}


// MARK: - EXTENSION - UIColor

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(Hex:Int) {
        self.init(red:(Hex >> 16) & 0xff, green:(Hex >> 8) & 0xff, blue:Hex & 0xff)
    }
    
    func isEqualToColor(_ otherColor : UIColor) -> Bool {
        if self == otherColor {
            return true
        }
        
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace : ((_ color : UIColor) -> UIColor?) = { (color) -> UIColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components : [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1] ]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            }
            else {
                return color;
            }
        }
        
        let selfColor = convertColorToRGBSpace(self)
        let otherColor = convertColorToRGBSpace(otherColor)
        
        if let selfColor = selfColor, let otherColor = otherColor {
            return selfColor.isEqual(otherColor)
        }
        else {
            return false
        }
    }
}

// MARK: - EXTENSION - UIButtons

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    
}


// MARK: - EXTENSION - UIView

public extension UIView {
    
    static func find<T>(of type: T.Type, in view: UIView, includeSubviews: Bool = true) -> T? where T: UIView {
        if view.isKind(of: T.self) {
            return view as? T
        }
        for subview in view.subviews {
            if subview.isKind(of: T.self) {
                return subview as? T
            } else if includeSubviews, let control = find(of: type, in: subview) {
                return control
            }
        }
        return nil
    }
    
    
    
    func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // 1
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha == 0 {
            return nil
        }
        //2
        var hitView: UIView? = self
        if !self.point(inside: point, with: event) {
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        //3
        for subview in self.subviews.reversed() {
            let insideSubview = self.convert(point, to: subview)
            if let sview = subview.overlapHitTest(point: insideSubview, withEvent: event) {
                return sview
            }
        }
        return hitView
    }
    
    /**
     Animació per moure vistes d'un costat a un altre. Normalment es faria servir
     per avisar a l'usuari que es deixa algun camp important
     */
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
    /**
     Animació d'una card quan es fa tap
     */
    func animateViewCellTap(isHighlighted: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHighlighted {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.transform = .identity
            }
        })
    }
    
    func addDashedBorder(cornerRadius: CGFloat) {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: (frameSize.width/2), y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 4
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}


// MARK: - EXTENSION - String

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    /**
     Dona un NSAttributedString amb els valors per defecte
     - Note: Valors per defecte
     - font-size: 12pt
     - color: black
     - font-family: Helvetica
     - text-align: center
     */
    var htmlToAttributedString: NSAttributedString? {
        
        let htmlCSSString = "<style>" +
        "html *" +
        "{" +
        "font-size: 12pt !important;" +
        "color: black !important;" +
        "font-family: Helvetica !important;" +
        "text-align: center;" +
        "}</style> \(self)"
        
        guard let data = htmlCSSString.data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    /**
     Retorna un NSAttributedString amb els valors rebuts per paràmetre
     
     - Parameter family: Familia per per el text
     - Parameter fontWeight: Estil per el text
     - Parameter textAlign: Alineació del text
     
     - Returns: String amb els atributs que ha rebut i sino els que te definits per defecte
     
     - Note: Valors per defecte
     - font-family: Helvetica
     - font-weight: normal
     - textAlign: left
     */
    func htmlAttributed(family: String? = "Helvetica", fontWeight: String? = "normal", textAlign: String = "left") -> NSAttributedString? {
        let htmlCSSString = "<style>" +
        "html *" +
        "{" +
        "font-weight: \(fontWeight!)" +
        "font-size: 12pt !important;" +
        "color: black !important;" +
        "font-family: \(family!) !important;" +
        "text-align: \(textAlign);" +
        "}</style> \(self)"
        
        guard let data = htmlCSSString.data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    public func splitedBy(length: Int) -> [String] {
        
        var result = [String]()
        
        for i in stride(from: 0, to: self.count, by: length) {
            let endIndex = self.index(self.endIndex, offsetBy: -i)
            let startIndex = self.index(endIndex, offsetBy: -length, limitedBy: self.startIndex) ?? self.startIndex
            result.append(String(self[startIndex..<endIndex]))
        }
        
        return result.reversed()
        
    }
    
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, count)]))
        }
        return result
    }
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count {
                result += separator
            }
        }
        return result
    }
    
    /**
     Dona format a uns String rebuts per paràmetre amb uns atributs concrets.
     
     - Important: Aquesta acció es pot realitzar amb el pod `FRHyperLabel` que ja està instal·lat al projecte
     
     - Parameter strings: Strings que els hi volem donar format
     - Parameter boldFont: Negreta, per defecte 15
     - Parameter boldColor: Color per la negreta, per defecte blau
     - Parameter string: Contingut de tot l'string que rebrà el format
     - Parameter color: Color que tindrà la resta del text
     
     - Returns: Retorna un NSAttributedString amb els atributs donats
     */
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 15),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
        NSMutableAttributedString(string: string,
                                  attributes: [
                                    NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        
        return attributedString
    }
    
    /**
     Canvia el format d'una data amb String cap a un altre format.
     
     - Parameter fromFormat: Format en què està la data
     - Parameter toFormat: Format en què volem la data
     
     - Returns: String amb el format de data que volem
     
     - Warning: Si es produeix un error, l'app no peta però retorna l'String `Can not format date`
     */
    func formatStrDate(fromFormat: String, toFormat: String) -> String {
        let dateFormatter = getDateFormatter(strFormat: fromFormat)
        
        if let d = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = toFormat
            return dateFormatter.string(from: d)
        }
        return "Can not format date"
    }
    
    /**
     Ens retorna un Date a partir d'una data que està en un format determinat
     
     - Parameter format: Format en què està la data String
     
     - Returns: Date a partir d'una data que estava amb String
     
     - Warning: Si es produeix un error l'app acabarà petant amb el text `Can not format date`
     */
    func date(format: String) -> Date {
        let dateFormatter = getDateFormatter(strFormat: format)
        if !self.isEmpty, let date = dateFormatter.date(from: self) {
            return date
        } else {
            fatalError("Can not format date")
        }
    }
    
    /**
     Converteix una data Date a una data String amb un format determinat
     
     - Parameter date: Data que volem convertir a String
     - Parameter format: Format que li volem donar a la data
     
     - Returns: String amb la data transformada amb un format determinat
     */
    func strDate(date: Date, format: String) -> String {
        let dateFormatter = getDateFormatter(strFormat: format)
        return dateFormatter.string(from: date)
    }
    
    func getDateFormatter(strFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        let localeId = UserDefaults.standard.string(forKey: "appLanguage") ?? "es"
        dateFormatter.locale = Locale(identifier: localeId)
        dateFormatter.dateFormat = strFormat
        return dateFormatter
    }
    
    /**
     Converteix un valor String a un Double per les monedes
     
     - Returns: El valor Double de la moneda que estava amb String
     
     - Note: Exemple
     - String del 'import `10.000,35 €`
     - Double de retorn `10000.35`
     */
    func stringToDoubleCurrency() -> Double {
        var strValue = self.replace(target: ".", withString: "")
        strValue = strValue.replace(target: ",", withString: ".")
        strValue = strValue.replace(target: " ", withString: "")
        strValue = strValue.replace(target: "€", withString: "")
        strValue = strValue.replace(target: "$", withString: "")
        
        return Double(strValue.isEmpty ? "0.0" : strValue) ?? 0.0
    }
    
    /**
     Dona format a l'String un TextField cada vegada que es van afegint números
     
     - Returns: String amb el format sense el símbol de la moneda
     
     - Bug: Pot donar problemes a l'hora de detectar la currency actual del dispositiu o ficar símbols extranys (iPhone XR)
     */
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        //		formatter.locale = Locale(identifier: "es_ES")
        //		formatter.currencySymbol = "$"
        
        var amountWithPrefix = self
        
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let characters = Array(self)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        let value = formatter.string(from: number)!
        return value.replace(target: "€", withString: "")
    }
    
    func calculateDifference(format: String, dateStart: Date, component: Set<Calendar.Component>) -> DateComponents {
        let startDay = self.date(format: format)
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: dateStart)
        let date2 = calendar.startOfDay(for: startDay)
        
        return calendar.dateComponents(component, from: date1, to: date2)
    }
}

// MARK: - EXTENSION - UIScreen

extension UIScreen {
    public func isRetina() -> Bool {
        return screenScale() >= CGFloat(2.0)
    }
    
    public func isRetinaHD() -> Bool {
        return screenScale() >= CGFloat(3.0)
    }
    
    fileprivate func screenScale() -> CGFloat {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            return UIScreen.main.scale
        }
        return 0.0
    }
    
    public func getScreen() -> String {
        if UIScreen.main.isRetinaHD()
        {
            return "retina3"
        }
        else if UIScreen.main.isRetina()
        {
            return "retina"
        }
        else
        {
            return "noretina"
        }
    }
    
    public func getWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public func getHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    public func getDev() -> String
    {
        let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
        
        if (isiPad) {
            return "tablet"
        }
        else {
            return "phone"
        }
    }
}

// MARK: - EXTENSION - UIImage

public extension UIImageView {
    
    func tintImage(color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }
    
}

public extension UIImage {
    
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image!.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

/*extension UITableView  {
 func sixAddPullToRefresh(_ refresh: PullToRefresh, action: @escaping () -> ()) {
 self.addPullToRefresh(refresh) {
 UIImpactFeedbackGenerator(style: .light).impactOccurred()
 action()
 }
 }
 }*/

// MARK: - EXTENSION - CAGradientLayer
extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: DATE
extension Date {
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    func formatToString(format:String = "dd-MM-yyyy hh-mm-ss") -> String {
        let dateFormatter = DateFormatter()
        let localeId = UserDefaults.standard.string(forKey: "appLanguage") ?? "es"
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: localeId)
        return dateFormatter.string(from: self)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

// MARK: - EXTENSION - UITextField

extension UITextField {
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                    let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
    
    func setLeftIcon(_ strImgName: String) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = UIImage(named: strImgName)
        iconView.contentMode = .scaleAspectFit
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.init(identifier: String(Locale.preferredLanguages[0].prefix(2)))
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "BKO".localized(), style: .plain, target: self, action: #selector(cancelPressed))
        cancelBarButton.tintColor = PRIMARY_COLOR
        let doneBarButton = UIBarButtonItem(title: "BOK".localized(), style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        doneBarButton.tintColor = PRIMARY_COLOR
        
        self.inputAccessoryView = toolBar
        
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
    
}

// MARK: - EXTENSION - UISearchBar

extension UISearchBar {
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    
    func setClearButton(color: UIColor) {
        getTextField()?.setClearButton(color: color)
    }
}

extension UIScrollView  {
    
    func addRefreshControl(action: Selector, target: Any?) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = PRIMARY_COLOR
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
}

extension UITableView  {
    func addCustomRefresh(action: Selector, target: Any?) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = PRIMARY_COLOR
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }
}

// MARK: - EXTENSION - UIBezierPath
extension UIBezierPath {
    
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != 0 {
            path.move(to: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y))
        } else {
            path.move(to: topLeft)
        }
        
        if topRightRadius != 0 {
            path.addLine(to: CGPoint(x: topRight.x - topRightRadius, y: topRight.y))
            path.addArc(tangent1End: topRight, tangent2End: CGPoint(x: topRight.x, y: topRight.y + topRightRadius), radius: topRightRadius)
        }
        else {
            path.addLine(to: topRight)
        }
        
        if bottomRightRadius != 0 {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius))
            path.addArc(tangent1End: bottomRight, tangent2End: CGPoint(x: bottomRight.x - bottomRightRadius, y: bottomRight.y), radius: bottomRightRadius)
        }
        else {
            path.addLine(to: bottomRight)
        }
        
        if bottomLeftRadius != 0 {
            path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius, y: bottomLeft.y))
            path.addArc(tangent1End: bottomLeft, tangent2End: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius), radius: bottomLeftRadius)
        }
        else {
            path.addLine(to: bottomLeft)
        }
        
        if topLeftRadius != 0 {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius))
            path.addArc(tangent1End: topLeft, tangent2End: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y), radius: topLeftRadius)
        }
        else {
            path.addLine(to: topLeft)
        }
        
        path.closeSubpath()
        cgPath = path
    }
}



// MARK: - EXTENSION - UIPageViewController
extension UIPageViewController {
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: {_ in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: true)
        })
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: {_ in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: true)
        })
    }
}
extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}


// MARK: - DOUBLE
extension Double {
    func toMoneyFormattedString() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return (formatter.string(from: self as NSNumber) ?? "0,0") + "€"
    }
}


// MARK: - EXTENSION - Vibration
enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    @available(iOS 13.0, *)
    case soft
    @available(iOS 13.0, *)
    case rigid
    case selection
    case oldSchool
    
    public func vibrate() {
        switch self {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

//-----------------------
// MARK: - CustomLogger
//-----------------------

enum LogTag {
    case error
    case warning
    case success
    case debug
    case network
    case simOnly
    case stop
    
    var label: String {
        switch self {
        case .error   : return "[APP ERROR 🔴]"
        case .warning : return "[APP WARNING 🟠]"
        case .success : return "[APP SUCCESS 🟢]"
        case .debug   : return "[APP DEBUG 🔵]"
        case .network : return "[APP NETWORK 🌍]"
        case .simOnly : return "[APP SIMULATOR ONLY 🤖]"
        case .stop : return "[APP FORCED TO STOP ☠️]"
        }
    }
}

func appLog(tag: LogTag = .debug, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        let shortFileName = file.components(separatedBy: "/").last ?? "---"
        
        let output = items.map {
            if let itm = $0 as? CustomStringConvertible {
                return "\(itm.description)"
            } else {
                return "\($0)"
            }
        }
            .joined(separator: " ")
        
        print("")
        var msg = "\(tag.label) \(shortFileName) - \(function) - line \(line)"
        if !output.isEmpty { msg += "\n\(output)" }
        print(msg)
    #else
        if tag == .stop {
            let shortFileName = file.components(separatedBy: "/").last ?? "---"
            
            let output = items.map {
                if let itm = $0 as? CustomStringConvertible {
                    return "\(itm.description)"
                } else {
                    return "\($0)"
                }
            }
                .joined(separator: " ")
            
            print("")
            var msg = "\(tag.label) \(shortFileName) - \(function) - line \(line)"
            if !output.isEmpty { msg += "\n\(output)" }
            //#error("Stopped")
        }
    #endif
}
