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
  
  public static func dismissAllToasts() {
    currentSmallToast?.dismiss()
    currentMediumToast?.dismiss()
  }
  
  public static func showSmallToast(
    _ title: String,
    subtitle: String? = nil,
    icon: AlertIcon? = nil,
    dismissByTap: Bool = true,
    dismissInTime: Bool = true,
    duration: TimeInterval = 1.5,
    haptic: AlertHaptic? = nil,
    titleLabelColor: UIColor? = nil,
    subtitleLabelColor: UIColor? = nil,
    iconTintColor: UIColor? = nil,
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
  
  public static func showMediumToast(
    _ title: String,
    subtitle: String? = nil,
    icon: AlertIcon? = nil,
    dismissByTap: Bool = true,
    dismissInTime: Bool = true,
    duration: TimeInterval = 1.5,
    haptic: AlertHaptic? = nil,
    titleLabelColor: UIColor? = nil,
    subtitleLabelColor: UIColor? = nil,
    iconTintColor: UIColor? = nil,
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
