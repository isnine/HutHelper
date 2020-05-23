//
//  NoticeHelper.swift
//  Show
//
//  Created by nine on 2018/9/10.
//

import Foundation
import SwiftMessages

public class NoticeHelper {
    static func showError(_ text: String) {
        showNotice(text, "请稍后再试", theme: .error)
    }
//    static func showSuccess(_ text: String) {
//        showNotice(text, theme: .success)
//    }
    static func showThanks(_ title: String) {
        showNotice(title, "app会因您变得更好", theme: .success, duration: .seconds(seconds: 3))
    }
    static func showNotice(_ title: String, _ body: String, theme: Theme, duration: SwiftMessages.Duration = .seconds(seconds: 0.1)) {
//        DispatchQueue.main.async {
        let view = MessageView.viewFromNib(layout: .cardView)

        // Theme message elements with the warning style.
        view.configureTheme(theme)

        // Add a drop shadow.
        view.configureDropShadow()
        view.button?.isHidden = true
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        var iconText = ""
        if theme == .success {
            iconText = "😁"
        } else if theme == .error {
            iconText = "☹️"
        }
        view.configureContent(title: title, body: body, iconText: iconText)

        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        // Reduce the corner radius (applicable to layouts featuring rounded corners).
      //  (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
//        var config = SwiftMessages.Config()
//        config.duration = duration
//        SwiftMessages.show(config: config,view: view)
        SwiftMessages.show(view: view)
    }
}
