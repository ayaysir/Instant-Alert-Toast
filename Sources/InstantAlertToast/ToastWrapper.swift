//
//  ToastWrapper.swift
//  InstantAlertToast
//
//  Created by 윤범태 on 3/4/26.
//

import UIKit

@MainActor
public extension Instant {
  private static var currentSmallToast: AlertAppleMusic17View?
  private static var currentMediumToast: AlertAppleMusic16View?
  private static var currentSpecialSmallToast: AlertAppleMusic17With1ButtonView?
  
  /// Dismisses all currently presented toast views.
  ///
  /// This method attempts to dismiss any small, medium, or special small toast
  /// that is currently being displayed.
  public static func dismissAllToasts() {
    currentSmallToast?.dismiss()
    currentMediumToast?.dismiss()
    currentSpecialSmallToast?.dismiss()
  }
  
  /// Displays a small toast message.
  ///
  /// - Parameters:
  ///   - title: The main title text of the toast.
  ///   - subtitle: The optional subtitle text displayed below the title.
  ///   - icon: An optional icon displayed alongside the text.
  ///   - dismissByTap: A Boolean value indicating whether the toast can be dismissed by tapping.
  ///   - dismissInTime: A Boolean value indicating whether the toast dismisses automatically after a duration.
  ///   - duration: The time interval after which the toast is dismissed automatically.
  ///   - haptic: An optional haptic feedback configuration.
  ///   - toastPresentHandler: A closure called after the toast is presented.
  public static func showSmallToast(
    _ title: String,
    subtitle: String? = nil,
    icon: AlertIcon? = nil,
    dismissByTap: Bool = true,
    dismissInTime: Bool = true,
    duration: TimeInterval = 1.5,
    haptic: AlertHaptic? = nil,
    // titleLabelColor: UIColor? = nil,
    // subtitleLabelColor: UIColor? = nil,
    // iconTintColor: UIColor? = nil,
    toastPresentHandler: (() -> Void)? = nil
  ) {
    guard let topViewController = UIApplication.shared.currentRootViewController?.getTopMostViewController() else {
      return
    }
    
    currentSmallToast?.dismiss()
    
    Self.currentSmallToast = AlertAppleMusic17View(
      title: title,
      subtitle: subtitle,
      icon: icon
    )
    
    /*
     open var dismissByTap: Bool = true
     open var dismissInTime: Bool = true
     open var duration: TimeInterval = 1.5
     open var haptic: AlertHaptic? = nil
     */
    
    guard let toast = Self.currentSmallToast else {
      return
    }
    
    toast.dismissByTap = dismissByTap
    toast.dismissInTime = dismissInTime
    toast.duration = duration
    toast.haptic = haptic
    
    toast.present(on: topViewController.view, completion: toastPresentHandler)
  }
  
  /// Displays a small toast message with a single action button.
  ///
  /// - Parameters:
  ///   - title: The main title text of the toast.
  ///   - subtitle: The optional subtitle text displayed below the title.
  ///   - icon: An optional icon displayed alongside the text.
  ///   - dismissByTap: A Boolean value indicating whether the toast can be dismissed by tapping.
  ///   - dismissInTime: A Boolean value indicating whether the toast dismisses automatically after a duration.
  ///   - duration: The time interval after which the toast is dismissed automatically.
  ///   - haptic: An optional haptic feedback configuration.
  ///   - toastPresentHandler: A closure called after the toast is presented.
  ///   - actionButtonHandler: A closure that provides a dismiss callback and is executed when the action button is tapped.
  public static func showSmallToastWithButton(
    _ title: String,
    subtitle: String? = nil,
    icon: AlertIcon? = nil,
    dismissByTap: Bool = true,
    dismissInTime: Bool = true,
    duration: TimeInterval = 1.5,
    haptic: AlertHaptic? = nil,
    // titleLabelColor: UIColor? = nil,
    // subtitleLabelColor: UIColor? = nil,
    // iconTintColor: UIColor? = nil,
    toastPresentHandler: (() -> Void)? = nil,
    actionButtonHandler: ((()->Void) -> Void)? = nil
  ) {
    guard let topViewController = UIApplication.shared.currentRootViewController?.getTopMostViewController() else {
      return
    }
    
    currentSpecialSmallToast?.dismiss()
    
    Self.currentSpecialSmallToast = AlertAppleMusic17With1ButtonView(
      title: title,
      subtitle: subtitle,
      icon: icon
    ) { dismiss in
      actionButtonHandler?(dismiss)
    }
    
    /*
     open var dismissByTap: Bool = true
     open var dismissInTime: Bool = true
     open var duration: TimeInterval = 1.5
     open var haptic: AlertHaptic? = nil
     */
    
    guard let toast = Self.currentSpecialSmallToast else {
      return
    }
    
    toast.dismissByTap = dismissByTap
    toast.dismissInTime = dismissInTime
    toast.duration = duration
    toast.haptic = haptic
    
    toast.present(on: topViewController.view, completion: toastPresentHandler)
  }
  
  /// Displays a medium-sized toast message.
  ///
  /// - Parameters:
  ///   - title: The main title text of the toast.
  ///   - subtitle: The optional subtitle text displayed below the title.
  ///   - icon: An optional icon displayed alongside the text.
  ///   - dismissByTap: A Boolean value indicating whether the toast can be dismissed by tapping.
  ///   - dismissInTime: A Boolean value indicating whether the toast dismisses automatically after a duration.
  ///   - duration: The time interval after which the toast is dismissed automatically.
  ///   - haptic: An optional haptic feedback configuration.
  ///   - toastPresentHandler: A closure called after the toast is presented.
  public static func showMediumToast(
    _ title: String,
    subtitle: String? = nil,
    icon: AlertIcon? = nil,
    dismissByTap: Bool = true,
    dismissInTime: Bool = true,
    duration: TimeInterval = 1.5, // dismissByTap이 true인 경우에만 유효
    haptic: AlertHaptic? = nil,
    // titleLabelColor: UIColor? = nil,
    // subtitleLabelColor: UIColor? = nil,
    // iconTintColor: UIColor? = nil,
    toastPresentHandler: (() -> Void)? = nil
  ) {
    guard let topViewController = UIApplication.shared.currentRootViewController?.getTopMostViewController() else {
      return
    }
    
    currentMediumToast?.dismiss()
    
    Self.currentMediumToast = AlertAppleMusic16View(
      title: title,
      subtitle: subtitle,
      icon: icon
    )
    
    /*
     open var dismissByTap: Bool = true
     open var dismissInTime: Bool = true
     open var duration: TimeInterval = 1.5
     open var haptic: AlertHaptic? = nil
     */
    
    guard let toast = Self.currentMediumToast else {
      return
    }
    
    toast.dismissByTap = dismissByTap
    toast.dismissInTime = dismissInTime
    toast.duration = duration
    toast.haptic = haptic
    
    toast.present(on: topViewController.view, completion: toastPresentHandler)
  }
}
