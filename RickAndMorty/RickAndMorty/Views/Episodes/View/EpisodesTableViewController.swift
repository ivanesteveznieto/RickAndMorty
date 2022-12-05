//
//  EpisodesTableViewController.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 4/12/22.
//

import UIKit
import Combine

final class EpisodesTableViewController: UITableViewController {
    private let viewModel: EpisodesViewModel
    private var subscriptions = Set<AnyCancellable>()
    private var seasons = [Season]()
    
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
        viewModel.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}

private extension EpisodesTableViewController {
    func bind() {
        viewModel.titlePublisher.sink { [unowned self] screenTitle in
            title = screenTitle
        }.store(in: &subscriptions)
        
        viewModel.episodesLoadedPublisher
            .receive(on: DispatchQueue.main)
            .sink { seasons in
                // TODO
            }.store(in: &subscriptions)
    }
}
