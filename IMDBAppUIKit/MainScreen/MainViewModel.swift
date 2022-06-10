//
//  MainViewModel.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

enum MainViewModelOutputEvent {
    case asyncOperationDidStart, asyncOperationDidEnd
    case imdbItemsDidLoad
}

enum MainViewModelInputEvent {
    case refreshingDidStart
    case viewWillAppear
}

protocol IMainViewModel: AnyObject {
    typealias EventHandler = ((IMainViewModel) -> ())
    func handle(event: MainViewModelInputEvent)
    @discardableResult
    func register(event: MainViewModelOutputEvent, handler: @escaping EventHandler) -> Self
    
    var items: [IMDBItem] { get }
}

final class MainViewModel: IMainViewModel {
    
    private let imdbService: IIMDBService
    
    private(set) var items: [IMDBItem] = [] {
        didSet {
            eventHandlers[.imdbItemsDidLoad]?(self)
        }
    }
    
    // MARK: - Init
    
    init(imdbService: IIMDBService) {
        self.imdbService = imdbService
    }
    
    // MARK: - Event Processing
    private var eventHandlers: [MainViewModelOutputEvent: EventHandler] = [:]
    
    func handle(event: MainViewModelInputEvent) {
        switch event {
        case .viewWillAppear, .refreshingDidStart: fetchMostPopularTVs()
        }
    }
    
    func register(event: MainViewModelOutputEvent, handler: @escaping EventHandler) -> Self {
        eventHandlers[event] = handler
        
        return self
    }
    
    // MARK: - IMainViewModel
    
    func fetchMostPopularTVs() {
        eventHandlers[.asyncOperationDidStart]?(self)
        
        imdbService.fetchMostPopularTVs { [weak self] in
            guard let self = self else { return }
            
            switch $0 {
            case .success(let items): self.items = items
            case .failure(let error): print(error)
            }
            
            self.eventHandlers[.asyncOperationDidEnd]?(self)
        }
    }
    
}
