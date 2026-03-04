import UIKit

internal protocol AlertViewProtocol {
  
  func present(on view: UIView, completion: (()->Void)?)
  func dismiss()
}
