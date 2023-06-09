//
//  NavigationUtil.swift
//  qddapp
//
//  Created by gabatx on 25/4/23.
//

import Foundation
import UIKit

// Clase que nos permite resetear la navegación y volver a la raiz del NavigationView
struct NavigationUtil {
  static func popToRootView() {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
      findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: true)
    }
  }

  static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
    guard let viewController = viewController else {
      return nil
    }

    if let navigationController = viewController as? UINavigationController {
      return navigationController
    }

    for childViewController in viewController.children {
      return findNavigationController(viewController: childViewController)
    }

    return nil
  }


}
