// The Swift Programming Language
// https://docs.swift.org/swift-book

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
  
  /// 간단한 OK 버튼 하나만 있는 UIAlert을 표시합니다.
  ///
  /// - Parameters:
  ///   - title: Alert의 제목 텍스트
  ///   - message: Alert의 본문 메시지 (옵션)
  ///   - okText: OK 버튼에 표시될 텍스트 (기본값: "OK")
  ///   - isAnimated: 표시 애니메이션 여부
  ///   - alertPresentHandler: Alert가 present된 직후 호출되는 클로저
  ///   - okHandler: OK 버튼 탭 시 실행되는 클로저
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
  
  /// 취소/확인 두 개의 버튼이 있는 확인용 UIAlert을 표시합니다.
  ///
  /// - Parameters:
  ///   - title: Alert의 제목 텍스트
  ///   - message: Alert의 본문 메시지 (옵션)
  ///   - cancelText: 취소 버튼 텍스트 (기본값: "Cancel")
  ///   - confirmText: 확인 버튼 텍스트 (기본값: "Confirm")
  ///   - isDestructiveConfirm: 확인 버튼을 destructive 스타일로 표시할지 여부
  ///   - isAnimated: 표시 애니메이션 여부
  ///   - alertPresentHandler: Alert가 present된 직후 호출되는 클로저
  ///   - cancelHandler: 취소 버튼 탭 시 실행되는 클로저
  ///   - confirmHandler: 확인 버튼 탭 시 실행되는 클로저
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
  
  /// 여러 개의 UIAlertAction을 커스텀으로 추가할 수 있는 UIAlert을 표시합니다.
  ///
  /// - Parameters:
  ///   - title: Alert의 제목 텍스트
  ///   - message: Alert의 본문 메시지 (옵션)
  ///   - isAnimated: 표시 애니메이션 여부
  ///   - actions: UIAlertAction 배열을 반환하는 클로저
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



