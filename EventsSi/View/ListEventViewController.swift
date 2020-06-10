//
//  ListEventViewController.swift
//  EventsSi
//
//  Created by Marcio Habigzang Brufatto on 09/06/20.
//  Copyright © 2020 Mantra Tech. All rights reserved.
//

import UIKit

class ListEventViewController: UIViewController {
    
    private var tableView: UITableView!
    private var listEventViewModel: ListEventViewModelProtocol
    private var activityindicator: UIActivityIndicatorView!
    
    init(listEventViewModelProtocol: ListEventViewModelProtocol? = nil) {
        self.listEventViewModel = listEventViewModelProtocol ?? ListEventViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupComponents()
        self.setupConstraints()
        
        listEventViewModel.loadEvents(completion: {(events) in
            self.tableView.reloadData()
        })
    }
    
    internal func setupComponents() {
        
        self.title = "Eventos"
        
        self.tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
    }
    
    internal func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ListEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEventViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        cell.event = listEventViewModel.eventAt(indexPath.row)
        return cell
    }
}

extension ListEventViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let networkManager = NetworkManager()
        let detailEventViewModel = DetailEventViewModel(networkManagerProtocol: networkManager)
        let detailViewController = DetailEventViewController(detailEventViewModelProtocol: detailEventViewModel)
        detailViewController.eventId = listEventViewModel.eventAt(indexPath.row).id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
