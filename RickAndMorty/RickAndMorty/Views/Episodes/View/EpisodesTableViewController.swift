//
//  EpisodesTableViewController.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import UIKit
import Combine

final class EpisodesTableViewController: UITableViewController {
    enum State {
        case idle, loading, data([Season])
    }
    private var state = State.idle
    private let viewModel: EpisodesViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var seasons = [Season]()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "EpisodesTableViewController", bundle: .main)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.viewDidLoad()
    }

    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int { seasons.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { seasons[section].episodes.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(EpisodeTableViewCell.self)", for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
        let episode = seasons[indexPath.section].episodes[indexPath.row]
        cell.bind(title: episode.title, airDate: episode.airDate)
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { seasons[section].seasonName }
}

// MARK: Private methods
private extension EpisodesTableViewController {
    func bind() {
        viewModel.titlePublisher.sink { [unowned self] screenTitle in
            title = screenTitle
        }.store(in: &subscriptions)
        
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.state = state
                switch state {
                case .idle: break
                case .loading:
                    showLoading()
                case .data(let seasons):
                    self.seasons = seasons
                    tableView.reloadData()
                    hideLoading()
                }
            }.store(in: &subscriptions)
    }
    
    func setupView() {
        setupActivityIndicatorView()
        setupTableView()
    }
    
    func setupActivityIndicatorView() {
        tableView.addSubview(activityIndicatorView)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .systemBlue
        activityIndicatorView.center = tableView.center
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "\(EpisodeTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(EpisodeTableViewCell.self)")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func showLoading() {
        activityIndicatorView.startAnimating()
    }
    
    func hideLoading() {
        activityIndicatorView.stopAnimating()
    }
}
