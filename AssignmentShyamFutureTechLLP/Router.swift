//
//  Router.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 14/02/23.
//

import Foundation
import SwiftUI

final class Router {
    
    public static func showMain(window: UIWindow? = UIApplication.shared.keyWindow) {
        Router.setRootView(view: ImageListView(), window: window)
    }
    
    private static func setRootView<T: View>(view: T, window: UIWindow? = nil) {
        if window != nil {
            window?.rootViewController = UIHostingController(rootView: view)
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
            return
        } else {
            UIApplication.shared.keyWindow?.rootViewController = UIHostingController(rootView: view)
            UIView.transition(with: UIApplication.shared.keyWindow!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
}
