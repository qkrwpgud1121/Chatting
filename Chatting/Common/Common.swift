//
//  CommonFunc.swift
//  Chatting
//
//  Created by 박제형 on 1/6/25.
//

import Foundation
import UIKit

class Common {
    
    let commonBasicColor = UIColor(hexCode: "769EFF")
    
    let connectedScene = UIApplication.shared.connectedScenes.first
    
    func getSafeAreaWidth() -> CGFloat {
        
        var safeAreaWidth: CGFloat = 0.0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            safeAreaWidth = CGFloat(window.safeAreaLayoutGuide.layoutFrame.width)
        }
        
        return safeAreaWidth
    }
    
    func getTopInsets() -> CGFloat {
        
        var insets: CGFloat = 0.0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            let safeAreaInset = window.safeAreaInsets
            insets = safeAreaInset.top
        }
        
        return insets
    }
    
    func getBottomInsets() -> CGFloat {
        
        var insets: CGFloat = 0.0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            let safeAreaInset = window.safeAreaInsets
            insets = safeAreaInset.bottom
        }
        
        return insets
    }
    
    func buttonConfig(pointSize: CGFloat, image: String,
                      top: CGFloat? = nil, leading: CGFloat? = nil, bottom: CGFloat? = nil, trailing: CGFloat? = nil, placement: String? = nil,
                      imagePadding: CGFloat? = nil  ) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .medium)
        config.preferredSymbolConfigurationForImage = imageConfig
        
        var contentInsets = NSDirectionalEdgeInsets()
        if let top = top { contentInsets.top = top }
        if let leading = leading { contentInsets.leading = leading }
        if let bottom = bottom { contentInsets.bottom = bottom }
        if let trailing = trailing { contentInsets.trailing = trailing }
        config.contentInsets = contentInsets
        
        switch placement {
        case "leading":
            config.imagePlacement = .leading
        case "trailing":
            config.imagePlacement = .trailing
        case "top":
            config.imagePlacement = .top
        case "bottom":
            config.imagePlacement = .bottom
        case .none:
            config.imagePlacement = .leading
        case .some(_):
            config.imagePlacement = .leading
        }
        
        config.imagePadding = CGFloat(imagePadding ?? 0)
        
        if image.contains("_") {
            config.image = UIImage(named: image)
        } else {
            config.image = UIImage(systemName: image)
        }
        
        return config
    }
    
    static func GF_DATE_TO_STRING(_ po_date: Date, _ ps_simpleFormat: String = "", po_locale: Locale = .current, pb_showTime: Bool = false) -> String {
        var returnStr = ""
        
        var format = !ps_simpleFormat.isEmpty ? ps_simpleFormat : (pb_showTime ? "yyyyMMddHHmmss" : "yyyyMMdd")
        let usingT = format.contains("'T'") // 포맷에 'T'가 있는 경우 작은따옴표 2개는 글자 수 카운트에서 제하기 위해 필요
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale   = po_locale
        dateFormatter.dateFormat = format
        
        returnStr = dateFormatter.string(from: po_date)
        
        // 해외 오류 방지용1: 해외에서 12시간제 쓰면 HH 포맷이 오류 나는 경우 있음 (애플 측 오류)
        if returnStr.count != (usingT ? format.count - 2 : format.count) {
            // 오전 오후 출력 포맷이 없는데 출력하는 오류 보완
            if !format.contains("a") {
                if returnStr.contains("오후") {
                    returnStr = returnStr.replacingOccurrences(of: "오후 ", with: "")
                    
                    let isShortHour = returnStr.count < (usingT ? format.count - 2 : format.count) // 1시, 3시 등 1글자인 경우 true, 10시, 11시 등 2글자인 경우 false
                    
                    let hour_start_idx = usingT ? format.indexOf("H")! - 2 : format.indexOf("H")!
                    let hour_end_idx = isShortHour ? hour_start_idx : (usingT ? format.lastIndexOf("H")! - 2 : format.lastIndexOf("H")!)
                    let hour_text_12 = returnStr.subStr(hour_start_idx, hour_end_idx + 1)
                    
                    // HH는 24시간제인데 포맷 오류로 인해 12시간제로 변환된 것이므로 다시 +12
                    if let hour_12 = Int(hour_text_12) {
                        returnStr = returnStr.subStr(hour_start_idx) + "\(hour_12 + 12)" + returnStr.subStrToLast(hour_end_idx + 1)
                    }
                }
                else if returnStr.contains("오전") {
                    returnStr = returnStr.replacingOccurrences(of: "오전 ", with: "")
                }
            }
        }
        
        // 해외 오류 방지용2: 해외에서 12시간제 쓰면 HH 포맷이 오류 생기는 경우가 있으므로 hh 포맷으로 한 번 더 시도 (애플 측 오류)
        /// 오전/오후 값까지 사용하는 경우 오후 5시도 오전 5시로 표기되는 문제가 있다
        if returnStr.isEmpty {
            format = format.replacingOccurrences(of: "H", with: "h")
            dateFormatter.dateFormat = format
            
            returnStr = dateFormatter.string(from: po_date)
        }
        
        return returnStr
    }
    
}
