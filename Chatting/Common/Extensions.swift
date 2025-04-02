//
//  Extensions.swift
//  Chatting
//
//  Created by 박제형 on 1/10/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension String {
    
    // Length
    var length: Int {
        return self.count
    }
    
    // IndexOf
    func indexOf(_ ps_target: String) -> Int? {
        let range = (self as NSString).range(of: ps_target)
        
        guard Range.init(range) != nil else {
            return nil
        }
        
        return range.location
    }
    
    // LastIndexOf
    func lastIndexOf(_ ps_target: String) -> Int? {
        let range = (self as NSString).range(of: ps_target, options: NSString.CompareOptions.backwards)
        
        guard Range.init(range) != nil else {
            return nil
        }
        
        return range.location
    }
    
    // substring 0 ~ pi_index 까지 자름
    func subStr(_ pi_index : Int) -> String {
        if self.length < pi_index {
            return self
        }
        return subStr(0,pi_index)
    }
    
    // substring pi_index ~ 끝까지 자름
    func subStrToLast(_ pi_index : Int) -> String {
        if self.length < pi_index {
            return self
        }
        return subStr(pi_index, self.length)
    }
    
    // SubString pi_startIdx ~ pi_endIdx 까지 자름
    func subStr(_ pi_startIdx : Int, _ pi_endIdx : Int) -> String{
        
        if ( self.length < pi_endIdx || self.length < pi_startIdx ) {
            return self
        }
        
        let lo_range = self.index(self.startIndex, offsetBy: pi_startIdx) ..< self.index(self.startIndex, offsetBy: pi_endIdx)
        return String(self[lo_range])
    }
    
    var isValidPhoneNum: Bool {
        
        if self.length == 0 {
            return false
        }
        
        if self.contains("-") {
            return NSPredicate(format: "SELF MATCHES %@", "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$").evaluate(with: self)
        }
        else {
            return NSPredicate(format: "SELF MATCHES %@", "^01([0|1|6|7|8|9]?)([0-9]{7,8})$").evaluate(with: self)
        }
        
    }
    
    var isValidEmail: Bool {
        if self.length == 0 {
            return false
        }
        
        let regEx = "[A-Z0-9a-z.]+@[A-Za-z0-9]+\\.[A-Za-z]{2,64}"
        
        return NSPredicate(format: "SELF MATCHES %@", regEx).evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        
        let ls_passRegEx1 = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,20}$" // 영문1+숫자1 필수 포함 영+숫+특 8~20자
        let ls_passRegEx2 = "^(?=.*[A-Za-z])(?=.*[!@#$%^&*()\\-_=+{}|?>.<,:;~`’])[A-Za-z0-9!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,20}$" // 영문1+특문1 필수 포함
        let ls_passRegEx3 = "^(?=.*[0-9])(?=.*[!@#$%^&*()\\-_=+{}|?>.<,:;~`’])[A-Za-z0-9!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,20}$" // 숫자1+특문1 필수 포함
        
        let lo_passRegEx1 = NSPredicate(format:"SELF MATCHES %@", ls_passRegEx1)
        let lo_passRegEx2 = NSPredicate(format:"SELF MATCHES %@", ls_passRegEx2)
        let lo_passRegEx3 = NSPredicate(format:"SELF MATCHES %@", ls_passRegEx3)
        
        return lo_passRegEx1.evaluate(with: self) || lo_passRegEx2.evaluate(with: self) || lo_passRegEx3.evaluate(with: self)
    }
}

extension UITextField {
    
    func setBottomBorder(color: UIColor? = UIColor.systemGray5, leftView: Bool? = true) {
        
        self.clearButtonMode = .whileEditing
        self.spellCheckingType = .no
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.textContentType = .none
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height - 2.0, width: self.frame.size.width, height: 2.0)
        border.backgroundColor = color!.cgColor
        self.layer.addSublayer(border)
        
        if leftView! {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
            self.leftViewMode = .always
        }
    }
    
}

extension UIImage {
    
    func resized(newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}

extension UILabel {
    
    func asFontColor(targetString: String, font: UIFont, color: UIColor) {
        let fullString = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullString)
        let range = (fullString as NSString).range(of: targetString)
        attributedString.addAttributes([.font: font as Any , .foregroundColor: color as Any], range: range)
        self.attributedText = attributedString
    }
}

extension UINavigationController {
    func setupBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .gray
        
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18.0),
                                          .foregroundColor: UIColor.orange]
        appearance.largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 35.0),
                                               .foregroundColor: UIColor.orange]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .red
        navigationBar.prefersLargeTitles = true
    }
    
}
