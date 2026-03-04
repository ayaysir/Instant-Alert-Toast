import UIKit

@available(iOS 13, *)
internal class AlertAppleMusic16View: UIView, @preconcurrency AlertViewProtocol {
  
  private var dismissWorkItem: DispatchWorkItem?
  
  // MARK: - 생성 후 커스터마이징 가능한 목록
  
  /// Alert를 탭했을 때 자동으로 dismiss할지 여부입니다.
  ///
  /// 기본값은 `true`이며, `false`로 설정하면 사용자가 탭해도 사라지지 않습니다.
  /// 스피너와 같이 강제 유지가 필요한 경우 `false`로 설정됩니다.
  internal var dismissByTap: Bool = true
  
  /// 일정 시간이 지난 후 자동으로 dismiss할지 여부입니다.
  ///
  /// 기본값은 `true`이며, `duration`에 설정된 시간 이후 자동으로 사라집니다.
  /// 로딩용 Alert의 경우 내부적으로 `false`로 설정됩니다.
  internal var dismissInTime: Bool = true
  
  /// 자동 dismiss까지 대기할 시간(초)입니다.
  ///
  /// `dismissInTime`이 `true`일 때만 적용됩니다.
  /// 기본값은 `1.5`초입니다.
  internal var duration: TimeInterval = 1.5
  
  /// Alert 표시 시 발생시킬 햅틱 피드백 설정입니다.
  ///
  /// `nil`이면 햅틱을 발생시키지 않으며,
  /// 값이 설정되면 `present()` 호출 시 `impact()`가 실행됩니다.
  internal var haptic: AlertHaptic? = nil
  
  // 초기화 시 설정하고 변경 불가능
  internal let titleLabel: UILabel?
  internal let subtitleLabel: UILabel?
  internal let iconView: UIView?
  
  internal static var defaultContentColor = UIColor { trait in
    switch trait.userInterfaceStyle {
    case .dark: return UIColor(red: 127 / 255, green: 127 / 255, blue: 129 / 255, alpha: 1)
    default: return UIColor(red: 88 / 255, green: 87 / 255, blue: 88 / 255, alpha: 1)
    }
  }
  
  // 비공개?
  fileprivate weak var viewForPresent: UIView?
  fileprivate var presentDismissDuration: TimeInterval = 0.2
  fileprivate var presentDismissScale: CGFloat = 0.8
  
  fileprivate var completion: (()->Void)? = nil
  
  private lazy var backgroundView: UIVisualEffectView = {
    let view: UIVisualEffectView = {
#if !os(tvOS)
      if #available(iOS 13.0, *) {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
      } else {
        return UIVisualEffectView(effect: UIBlurEffect(style: .light))
      }
#else
      return UIVisualEffectView(effect: UIBlurEffect(style: .light))
#endif
    }()
    view.isUserInteractionEnabled = false
    return view
  }()
  
  internal init(title: String? = nil, subtitle: String? = nil, icon: AlertIcon? = nil) {
    
    if let title = title {
      let label = UILabel()
      label.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
      label.numberOfLines = 0
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 3
      style.alignment = .center
      label.attributedText = NSAttributedString(string: title, attributes: [.paragraphStyle: style])
      titleLabel = label
    } else {
      self.titleLabel = nil
    }
    
    if let subtitle = subtitle {
      let label = UILabel()
      label.font = UIFont.preferredFont(forTextStyle: .body)
      label.numberOfLines = 0
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 2
      style.alignment = .center
      label.attributedText = NSAttributedString(string: subtitle, attributes: [.paragraphStyle: style])
      subtitleLabel = label
    } else {
      self.subtitleLabel = nil
    }
    
    if let icon = icon {
      let view = icon.createView(lineThick: 9)
      self.iconView = view
    } else {
      self.iconView = nil
    }
    
    if icon == nil {
      layout = AlertLayout.message()
    } else {
      layout = AlertLayout(for: icon ?? .heart)
    }
    
    self.titleLabel?.textColor = Self.defaultContentColor
    self.subtitleLabel?.textColor = Self.defaultContentColor
    self.iconView?.tintColor = Self.defaultContentColor
    
    super.init(frame: .zero)
    
    preservesSuperviewLayoutMargins = false
    insetsLayoutMarginsFromSafeArea = false
    
    backgroundColor = .clear
    addSubview(backgroundView)
    
    if let titleLabel = self.titleLabel {
      addSubview(titleLabel)
    }
    if let subtitleLabel = self.subtitleLabel {
      addSubview(subtitleLabel)
    }
    if let iconView = self.iconView {
      addSubview(iconView)
    }
    
    layoutMargins = layout.margins
    
    layer.masksToBounds = true
    layer.cornerRadius = 8
    layer.cornerCurve = .continuous
    
    switch icon {
    case .spinnerSmall, .spinnerLarge:
      dismissInTime = false
      dismissByTap = false
    default:
      dismissInTime = true
      dismissByTap = true
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func present(on view: UIView, completion: (()->Void)? = nil) {
    self.viewForPresent = view
    self.completion = completion
    viewForPresent?.addSubview(self)
    guard let viewForPresent = viewForPresent else { return }
    
    alpha = 0
    sizeToFit()
    center = .init(x: viewForPresent.frame.midX, y: viewForPresent.frame.midY)
    transform = transform.scaledBy(x: self.presentDismissScale, y: self.presentDismissScale)
    
    if dismissByTap {
      let tapGesterRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss))
      addGestureRecognizer(tapGesterRecognizer)
    }
    
    // Present
    
    haptic?.impact()
    
    UIView.animate(withDuration: presentDismissDuration, animations: {
      self.alpha = 1
      self.transform = CGAffineTransform.identity
    }, completion: { [weak self] finished in
      guard let self = self else { return }
      
      if let iconView = self.iconView as? AlertIconAnimatable {
        iconView.animate()
      }
      
      if self.dismissInTime {
        // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration) {
        //   // If dismiss manually no need call original completion.
        //   if self.alpha != 0 {
        //     self.dismiss()
        //   }
        // }
        
        dismissWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
          self?.dismiss()
        }
        
        dismissWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.duration, execute: workItem)
      }
    })
  }
  
  @objc open func dismiss() {
    self.dismiss(customCompletion: self.completion)
  }
  
  func dismiss(customCompletion: (()->Void)? = nil) {
    UIView.animate(withDuration: presentDismissDuration, animations: {
      self.alpha = 0
      self.transform = self.transform.scaledBy(x: self.presentDismissScale, y: self.presentDismissScale)
    }, completion: { [weak self] finished in
      self?.dismissWorkItem?.cancel()
      self?.dismissWorkItem = nil
      
      self?.removeFromSuperview()
      customCompletion?()
    })
  }
  
  private let layout: AlertLayout
  
  internal override func layoutSubviews() {
    super.layoutSubviews()
    
    guard self.transform == .identity else { return }
    backgroundView.frame = self.bounds
    
    if let iconView = self.iconView {
      iconView.frame = .init(origin: .init(x: 0, y: layoutMargins.top), size: layout.iconSize)
      iconView.center.x = bounds.midX
    }
    if let titleLabel = self.titleLabel {
      titleLabel.layoutDynamicHeight(
        x: layoutMargins.left,
        y: iconView == nil ? layoutMargins.top : (iconView?.frame.maxY ?? 0) + layout.spaceBetweenIconAndTitle,
        width: frame.width - layoutMargins.left - layoutMargins.right)
    }
    if let subtitleLabel = self.subtitleLabel {
      let yPosition: CGFloat = {
        if let titleLabel = self.titleLabel {
          return titleLabel.frame.maxY + 4
        } else {
          return layoutMargins.top
        }
      }()
      subtitleLabel.layoutDynamicHeight(x: layoutMargins.left, y: yPosition, width: frame.width - layoutMargins.left - layoutMargins.right)
    }
  }
  
  internal override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width: CGFloat = 250
    self.frame = .init(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.height)
    layoutSubviews()
    let height = subtitleLabel?.frame.maxY ?? titleLabel?.frame.maxY ?? iconView?.frame.maxY ?? .zero
    return .init(width: width, height: height + layoutMargins.bottom)
  }
  
  private class AlertLayout {
    
    var iconSize: CGSize
    var margins: UIEdgeInsets
    var spaceBetweenIconAndTitle: CGFloat
    
    internal init(iconSize: CGSize, margins: UIEdgeInsets, spaceBetweenIconAndTitle: CGFloat) {
      self.iconSize = iconSize
      self.margins = margins
      self.spaceBetweenIconAndTitle = spaceBetweenIconAndTitle
    }
    
    convenience init() {
      self.init(iconSize: .init(width: 100, height: 100), margins: .init(top: 43, left: 16, bottom: 25, right: 16), spaceBetweenIconAndTitle: 41)
    }
    
    static func message() -> AlertLayout {
      let layout = AlertLayout()
      layout.margins = UIEdgeInsets(top: 23, left: 16, bottom: 23, right: 16)
      return layout
    }
    
    convenience init(for preset: AlertIcon) {
      switch preset {
      case .done:
        self.init(
          iconSize: .init(
            width: 112,
            height: 112
          ),
          margins: .init(
            top: 63,
            left: Self.defaultHorizontalInset,
            bottom: 29,
            right: Self.defaultHorizontalInset
          ),
          spaceBetweenIconAndTitle: 35
        )
      case .heart:
        self.init(
          iconSize: .init(
            width: 112,
            height: 77
          ),
          margins: .init(
            top: 49,
            left: Self.defaultHorizontalInset,
            bottom: 25,
            right: Self.defaultHorizontalInset
          ),
          spaceBetweenIconAndTitle: 35
        )
      case .error:
        self.init(
          iconSize: .init(
            width: 86,
            height: 86
          ),
          margins: .init(
            top: 63,
            left: Self.defaultHorizontalInset,
            bottom: 29,
            right: Self.defaultHorizontalInset
          ),
          spaceBetweenIconAndTitle: 39
        )
      case .spinnerLarge, .spinnerSmall:
        self.init(
          iconSize: .init(
            width: 16,
            height: 16
          ),
          margins: .init(
            top: 58,
            left: Self.defaultHorizontalInset,
            bottom: 27,
            right: Self.defaultHorizontalInset
          ),
          spaceBetweenIconAndTitle: 39
        )
      case .custom(_):
        self.init(
          iconSize: .init(
            width: 100,
            height: 100
          ),
          margins: .init(
            top: 43,
            left: Self.defaultHorizontalInset,
            bottom: 25,
            right: Self.defaultHorizontalInset
          ),
          spaceBetweenIconAndTitle: 35
        )
      }
    }
    
    private static var defaultHorizontalInset: CGFloat { return 16 }
  }
}
