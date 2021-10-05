//
//  MainViewController.swift
//  Repositories
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let searchController: UISearchController = .init()
    
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        viewModel.delegate = self
        tableView.register(UINib(nibName: String(describing: ListTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: ListTableViewCell.identifier)
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        // TODO: Remove
        viewModel.search("al")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - MainViewModel Protocol

extension MainViewController: MainViewModelProtocol {
    
}

// MARK: - TextField Delegate

extension MainViewController: UITextFieldDelegate {
    
}

// MARK: - TableView DataSource/Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.displayData(viewModel.getCellData(at: indexPath.row))
        return cell
    }
}
