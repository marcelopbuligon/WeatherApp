//
//  WeatherWeekdayController.swift
//  weatherApp
//
//  Created by Marcelo Pagliarini Buligon on 20/05/20.
//  Copyright © 2020 Marcelo Pagliarini Buligon. All rights reserved.
//

import UIKit

final class WeekdayViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView?
    
    private let spinner = SpinnerController()
    private let pullControl = UIRefreshControl()
    private let presenter: WeekdayPresenter
    
    init(presenter: WeekdayPresenter) {
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
        pullToRefresh()
    }
    
    private func setupTableView() {
        tableView?.register(WeekdayTableViewCell.nib,forCellReuseIdentifier: WeekdayTableViewCell.identifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    private func pullToRefresh() {
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView?.refreshControl = pullControl
        } else {
            tableView?.addSubview(pullControl)
        }
    }
    
    @objc private func refreshListData(_ sender: Any) {
        presenter.setupWeatherService()
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
        pullControl.endRefreshing()
        presenter.pullToRefreshDidHappen()
    }
}

// MARK: - TableView Delegate/DataSource

extension WeekdayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell( withIdentifier: WeekdayTableViewCell.identifier, for: indexPath) as? WeekdayTableViewCell else { return UITableViewCell() }
        let dayOfWeek = presenter.dataSource[indexPath.row]
        let presenter = WeekdayCellPresenter(model: dayOfWeek)
        cell.configure(presenter: presenter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeader = UIView()
        customHeader.backgroundColor = UIColor.systemBackground
        return customHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.rowDidTap(indexPath.row)
    }
}

// MARK: - Presenter output

extension WeekdayViewController: WeekdayPresenterDelegate {
    
    func pullEndFreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.pullControl.endRefreshing()
        }
    }
    
    func setupNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setupNavigationBackButton(_ title: String) {
        setBackButton(title: title)
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
    
    func showAlert(message: String, buttonTitle: String) {
        let dialogMessage = UIAlertController(
            title: message,
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
}
