//
//  Coordinator.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import UIKit

protocol ICoordinator {
    func start()
}

final class Coordinator: ICoordinator {
    private var window: UIWindow
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - ICoordinator
    
    func start() {
        
    #warning("It's not really coordinator, just a little visualisation of it, for real app we will need DI system and inject build all units there !!!. ")
        
        let httpClient = HTTPClient(urlSession: URLSession(configuration: .default))
        let imdbService = IMDBService(httpClient: httpClient)
        let viewModel = MainViewModel(imdbService: imdbService)
        let viewController = try! MainViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
}
