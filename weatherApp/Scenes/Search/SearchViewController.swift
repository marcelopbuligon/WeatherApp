//
//  WeatherSearchViewController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 16/06/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView?
    
    private let spinner = SpinnerController()
    private let cellIdentifier = "CityCell"
    private let searchController = UISearchController(searchResultsController: nil)
    private let presenter: SearchPresenter
    
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        setupTableView()
        setupSearchBar()
        setupNavigationBar()
        navigationBarTitleAnimation()
    }
    
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = localizable.welcomePage.searchBar.localized
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        setBackButton(title: localizable.welcomePage.title.localized)
    }
    
    private func navigationBarTitleAnimation() {
        title = ""
        var charIndex = 0.0
        let titleText = localizable.welcomePage.title.localized
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.title?.append(letter)
            }
            charIndex += 1
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputTextByUser = searchController.searchBar.text else { return }
        presenter.inputTextDidChange(inputTextByUser)
    }
}

// MARK: - TableView Delegate/DataSource

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let city = presenter.dataSource[indexPath.row]
        cell.textLabel?.text = city.title
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.rowDidTap(indexPath.row)
    }
}

// MARK: - Presenter output

extension SearchViewController: SearchPresenterDelegate {
    
    func resetSearchBarText() {
        searchController.searchBar.text = ""
    }
    
    func showAlert(message: String, buttonTitle: String, title: String) {
        let dialogMessage = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let tryAgainButton = UIAlertAction(
            title: buttonTitle,
            style: .default,
            handler: { [weak self] _ -> Void in
                self?.presenter.tryAgainButtonDidTap()
        })
        
        dialogMessage.addAction(tryAgainButton)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func showLoading() {
        spinner.show()
        addChild(spinner)
        view.addSubview(spinner.view)
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.spinner.hide()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
}
