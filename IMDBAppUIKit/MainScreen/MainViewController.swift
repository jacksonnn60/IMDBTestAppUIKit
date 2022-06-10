//
//  ViewController.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import UIKit
import WebKit

final class MainViewController: UIViewController {

    // MARK: - @IBOutlet
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - ViewModel
    
    var viewModel: IMainViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(refreshCollectionView(_:)), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = self
        collectionView.delegate = self
        
        registerOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.handle(event: .viewWillAppear)
    }
}

// MARK: -

private extension MainViewController {
    @objc func refreshCollectionView(_ sender: UIRefreshControl) {
        viewModel?.handle(event: .refreshingDidStart)
    }
}

// MARK: - Processing Outputs

private extension MainViewController {
    func registerOutputs() {
        viewModel?
            .register(event: .asyncOperationDidStart) { [weak self] viewModel in
                DispatchQueue.main.async {
                    self?.showLoader()
                }
            }
            .register(event: .asyncOperationDidEnd) { [weak self] viewModel in
                DispatchQueue.main.async {
                    self?.hideLoader()
                }
            }
            .register(event: .imdbItemsDidLoad) { [weak self] viewModel in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.refreshControl.endRefreshing()
                    
                    UIView.transition(with: self.collectionView, duration: 0.35, options: .transitionCrossDissolve) {
                        self.collectionView.reloadData()
                    }
                }
            }
    }
}


// MARK: - UICollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMDItemCollectionViewCell.identifier, for: indexPath) as? IMDItemCollectionViewCell,
              let item = viewModel?.items[indexPath.item] else {
            return .init()
        }
        
        if let imageUrl = URL(string: item.image) {
            cell.imageView.setImage(from:  imageUrl)
        }
        
        cell.descriptionLabel.text = item.crew
        cell.titleLabel.text = item.title
        cell.rankLabel.text = item.rank
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.items[indexPath.item] else {
            return
        }
        
        
        let query = item.title.split(separator: " ").joined(separator: "+")
        showWebView(for: "https://www.google.com/search?q=\(query)")
    }
}

// MARK: - WebView

private extension UIViewController {
    func showWebView(for url: String) {
        guard let url = URL(string: url) else {
            return print("Error: Invalid URL.")
        }
        
        let webView = WKWebView(frame: view.bounds)
        let webController = UIViewController()
        webController.view = webView
        webView.load(URLRequest(url: url))
        
        present(webController, animated: true)
    }
}
