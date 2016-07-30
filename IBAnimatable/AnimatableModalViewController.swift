//
//  Created by Tom Baranes on 16/07/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

import UIKit

/// `AnimatableModalViewController` is a customised modal view controller used as the `presentedViewController` for `UIPresentationController`. We can use it in Interface Builder to style the modal view and dimming view. Also configure the presentation and dismissal animations.
public class AnimatableModalViewController: UIViewController, PresentationDesignable {

  // MARK: - AnimatablePresentationController

  /// Presentation animation type, all supported animation type can be found in `PresentationAnimationType`
  @IBInspectable public var presentationAnimationType: String? {
    didSet {
      setupPresenter()
    }
  }

  /// Dismissal animation type, all supported animation type can be found in `PresentationAnimationType`
  @IBInspectable public var dismissalAnimationType: String? {
    didSet {
      setupPresenter()
    }
  }

  /// Tranistion duration
  @IBInspectable public var transitionDuration: Double = .NaN {
    didSet {
      presenter?.transitionDuration = transitionDuration
    }
  }

  // Modal position, all supported modal position can be found in `PresentationModalPosition`
  @IBInspectable public var modalPosition: String = "Center" {
    didSet {
      presenter?.presentionConfiguration?.modalPosition = PresentationModalPosition.fromString(modalPosition)
    }
  }

  // Modal width, all supported modal width can be found in `PresentationModalSize`
  @IBInspectable public var modalWidth: String = "Half" {
    didSet {
      presenter?.presentionConfiguration?.modalSize = (PresentationModalSize.fromString(modalWidth), PresentationModalSize.fromString(modalHeight))
    }
  }

  // Modal height, all supported modal width can be found in `PresentationModalSize`
  @IBInspectable public var modalHeight: String = "Half" {
    didSet {
      presenter?.presentionConfiguration?.modalSize = (PresentationModalSize.fromString(modalWidth), PresentationModalSize.fromString(modalHeight))
    }
  }

  /// The corner radius of the modal view
  @IBInspectable public var cornerRadius: CGFloat = .NaN {
    didSet {
      presenter?.presentionConfiguration?.cornerRadius = cornerRadius
    }
  }

  /// If set to `true`, the modal view will dismiss when tap on the dimming view.
  @IBInspectable public var dismissOnTap: Bool = true {
    didSet {
      presenter?.presentionConfiguration?.dismissOnTap = dismissOnTap
    }
  }

  /// The background color of the dimming view. The default value is black color.
  @IBInspectable public var backgroundColor: UIColor = .blackColor() {
    didSet {
      presenter?.presentionConfiguration?.backgroundColor = backgroundColor
    }
  }

  // The opacity of the dimming view. The default value is `0.7`.
  @IBInspectable public var opacity: CGFloat = 0.7 {
    didSet {
      presenter?.presentionConfiguration?.opacity = opacity
    }
  }

  // The blur effect style of the dimming view. If use this property, `backgroundColor` and `opacity` are ignored.
  @IBInspectable public var blurEffectStyle: String? {
    didSet {
      presenter?.presentionConfiguration?.blurEffectStyle = blurEffectStyle
    }
  }

  // The blur opacity of the dimming view. If use this property, `backgroundColor` and `opacity` are ignored.
  @IBInspectable public var blurOpacity: CGFloat = .NaN {
    didSet {
      presenter?.presentionConfiguration?.blurOpacity = blurOpacity
    }
  }

  // The shadow color of the modal view. If use this property, `cornerRadius` is ignored.
  @IBInspectable public var shadowColor: UIColor? {
    didSet {
      presenter?.presentionConfiguration?.shadowColor = shadowColor
    }
  }

  // The shadow radius of the modal view. If use this property, `cornerRadius` is ignored.
  @IBInspectable public var shadowRadius: CGFloat = CGFloat.NaN {
    didSet {
      presenter?.presentionConfiguration?.shadowRadius = shadowRadius
    }
  }

  // The shadow opacity of the modal view. If use this property, `cornerRadius` is ignored.
  @IBInspectable public var shadowOpacity: CGFloat = CGFloat.NaN {
    didSet {
      presenter?.presentionConfiguration?.shadowOpacity = shadowOpacity
    }
  }

  // The shadow offset of the modal view. If use this property, `cornerRadius` is ignored.
  @IBInspectable public var shadowOffset: CGPoint = CGPoint(x: CGFloat.NaN, y: CGFloat.NaN) {
    didSet {
      presenter?.presentionConfiguration?.shadowOffset = shadowOffset
    }
  }

  // MARK: Private

  private var presenter: PresentationPresenter?

  // MARK: Life cycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupPresenter()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupPresenter()
  }

  // MARK: Life cycle

  override public func viewDidLoad() {
    super.viewDidLoad()
  }

  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let animationType = PresentationAnimationType.fromString(dismissalAnimationType ?? "") ?? PresentationAnimationType.Cover(fromDirection: .Bottom)
    if let dismissSystemTransition = animationType.systemTransition {
      modalTransitionStyle = dismissSystemTransition
    }
  }
}

private extension AnimatableModalViewController {
  func setupPresenter() {
    let animationType = PresentationAnimationType.fromString(presentationAnimationType ?? "") ?? PresentationAnimationType.Cover(fromDirection: .Bottom)
    presenter = PresentationPresenterManager.sharedManager().retrievePresenter(animationType, transitionDuration: transitionDuration)
    presenter?.dismissalAnimationType = PresentationAnimationType.fromString(dismissalAnimationType ?? "")
    transitioningDelegate = presenter
    modalPresentationStyle = .Custom
    if let systemTransition = animationType.systemTransition {
      modalTransitionStyle = systemTransition
    }
    
    var presentionConfiguration = PresentionConfiguration()
    presentionConfiguration.modalPosition = PresentationModalPosition.fromString(modalPosition)
    presentionConfiguration.modalSize = (PresentationModalSize.fromString(modalWidth), PresentationModalSize.fromString(modalHeight))
    presentionConfiguration.cornerRadius = cornerRadius
    presentionConfiguration.dismissOnTap = dismissOnTap
    presentionConfiguration.backgroundColor = backgroundColor
    presentionConfiguration.opacity = opacity
    presentionConfiguration.blurEffectStyle = blurEffectStyle
    presentionConfiguration.blurOpacity = blurOpacity
    presentionConfiguration.shadowColor = shadowColor
    presentionConfiguration.shadowOpacity = shadowOpacity
    presentionConfiguration.shadowRadius = shadowRadius
    presentionConfiguration.shadowOffset = shadowOffset
    presenter?.presentionConfiguration = presentionConfiguration
  }
}