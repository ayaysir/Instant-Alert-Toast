//
//  Extensions.swift
//  InstantAlertToast
//
//  Created by 윤범태 on 3/4/26.
//

import UIKit

extension UIApplication {
  var firstScene: UIWindowScene? {
    self.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
  }
  
  var firstWindow: UIWindow? {
    guard let scene = firstScene else { return nil }
    return scene.windows.first(where: { $0.isKeyWindow })
  }
  
  var currentRootViewController: UIViewController? {
    firstWindow?.rootViewController
  }
}

extension UIViewController {
  
  /// 현재 표시된 최상위 뷰 컨트롤러 반환
  func getTopMostViewController() -> UIViewController {
    if let presentedViewController = self.presentedViewController {
      return presentedViewController.getTopMostViewController()
    } else if let navigationController = self as? UINavigationController {
      return navigationController.visibleViewController?.getTopMostViewController() ?? navigationController
    } else if let tabBarController = self as? UITabBarController {
      return tabBarController.selectedViewController?.getTopMostViewController() ?? tabBarController
    } else {
      return self
    }
  }
}
