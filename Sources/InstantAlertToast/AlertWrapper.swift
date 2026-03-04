//
//  AlertWrapper.swift
//  InstantAlertToast
//
//  Created by 윤범태 on 3/4/26.
//

import UIKit

public struct Instant {
  public struct Configuration {
    // Alerts
    public var alertOkText = "OK"
    public var alertCancelText = "Cancel"
    public var alertConfirmText = "Confirm"
    
    // Toasts
  }
  
  @MainActor public static var configuration = Configuration()
  
  private static func makeEmptyAlert(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style
  ) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: preferredStyle
    )
    
    return alert
  }
  
  @MainActor static func presentInMainAsync(
    _ vc: UIViewController,
    animated isAnimated: Bool,
    completion: (() -> Void)? = nil
  ) {
    DispatchQueue.main.async {
      if let topViewController = UIApplication.shared.currentRootViewController?.getTopMostViewController() {
        topViewController.present(vc, animated: isAnimated, completion: completion)
      }
    }
  }
  
  /// Displays a UIAlert with a single OK button.
  ///
  /// - Parameters:
  ///   - title: The title text of the alert.
  ///   - message: The message body of the alert (optional).
  ///   - okText: The text displayed on the OK button (default: "OK").
  ///   - isAnimated: A Boolean value indicating whether the alert presentation is animated.
  ///   - alertPresentHandler: A closure called immediately after the alert is presented.
  ///   - okHandler: A closure executed when the OK button is tapped.
  @MainActor
  public static func showSimpleAlert(
    _ title: String,
    message: String? = nil,
    okText: String? = nil,
    isAnimated: Bool = true,
    alertPresentHandler: (() -> Void)? = nil,
    okHandler: ((UIAlertAction) -> Void)? = nil,
  ) {
    let alert = Self.makeEmptyAlert(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(
      title: okText ?? configuration.alertOkText,
      style: .default,
      handler: okHandler
    )
    alert.addAction(alertAction)
    
    Self.presentInMainAsync(alert, animated: isAnimated, completion: alertPresentHandler)
  }
  
  /// Displays a confirmation UIAlert with Cancel and Confirm buttons.
  ///
  /// - Parameters:
  ///   - title: The title text of the alert.
  ///   - message: The message body of the alert (optional).
  ///   - cancelText: The text displayed on the Cancel button (default: "Cancel").
  ///   - confirmText: The text displayed on the Confirm button (default: "Confirm").
  ///   - isDestructiveConfirm: A Boolean value indicating whether the Confirm button uses the destructive style.
  ///   - isAnimated: A Boolean value indicating whether the alert presentation is animated.
  ///   - alertPresentHandler: A closure called immediately after the alert is presented.
  ///   - cancelHandler: A closure executed when the Cancel button is tapped.
  ///   - confirmHandler: A closure executed when the Confirm button is tapped.
  @MainActor public static func showConfirmAlert(
    _ title: String,
    message: String? = nil,
    cancelText: String? = nil,
    confirmText: String? = nil,
    isDestructiveConfirm: Bool = false,
    isAnimated: Bool = true,
    alertPresentHandler: (() -> Void)? = nil,
    cancelHandler: ((UIAlertAction) -> Void)? = nil,
    confirmHandler: ((UIAlertAction) -> Void)?
  ) {
    let alert = Self.makeEmptyAlert(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(
      title: cancelText ?? configuration.alertCancelText,
      style: .cancel,
      handler: cancelHandler
    )
    let confirmAction = UIAlertAction(
      title: confirmText ?? configuration.alertConfirmText,
      style: isDestructiveConfirm ? .destructive : .default,
      handler: confirmHandler
    )
    alert.addAction(cancelAction)
    alert.addAction(confirmAction)
    
    Self.presentInMainAsync(alert, animated: isAnimated, completion: alertPresentHandler)
  }
  
  /// Displays a UIAlert that allows adding multiple custom UIAlertAction items.
  ///
  /// - Parameters:
  ///   - title: The title text of the alert.
  ///   - message: The message body of the alert (optional).
  ///   - isAnimated: A Boolean value indicating whether the alert presentation is animated.
  ///   - actions: A closure that returns an array of UIAlertAction instances to be added to the alert.
  @MainActor public static func showAlertWithMultipleActions(
    _ title: String,
    message: String? = nil,
    isAnimated: Bool = true,
    actions: (() -> [UIAlertAction])
  ) {
    let alert = Self.makeEmptyAlert(title: title, message: message, preferredStyle: .alert)
    for action in actions() {
      alert.addAction(action)
    }
    
    Self.presentInMainAsync(alert, animated: isAnimated)
  }
}
