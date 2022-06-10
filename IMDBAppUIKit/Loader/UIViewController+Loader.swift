//
//  UIViewController+Loader.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import UIKit

extension UIViewController {
    func showLoader(_ completion: (() -> Void)? = nil) {
        if let loaderController = getLoaderController() {
            loaderController.dismiss(animated: false) { [weak self ] in
                self?.showLoader(completion)
            }
        }
        
        guard let loaderController = try? LoaderViewController.loadFromStoryboard(),
              let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let controller = window.rootViewController else {
                  return
              }
        
        loaderController.modalPresentationStyle = .overFullScreen
        
        DispatchQueue.main.async { [weak self] in
            self?.getTopController(from: controller)?.present(loaderController, animated: true) {
                completion?()
            }
        }
    }
    
    var isLoadingAnimationPresented: Bool {
        getLoaderController() != nil
    }
    
    func hideLoader(endBlock: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let loaderController = self?.getLoaderController() else {
                return
            }
            loaderController.dismiss(animated: true, completion: {
                endBlock?()
            })
        }
    }
    
    private func getLoaderController() -> LoaderViewController? {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let controller = window.rootViewController,
              let presentedController = getTopController(from: controller) as? LoaderViewController else {
                  return nil
              }
        
        return presentedController
    }
    
    private func getTopController(from controller: UIViewController) -> UIViewController? {
        if let top = controller.presentedViewController {
            return getTopController(from: top)
        }
        return controller
    }
    
}
