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
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showLazyLoader() {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.frame = .init(x: 0,
                              y: 0,
                              width: tableView.bounds.width,
                              height: 44)
        spinner.startAnimating()
        tableView.tableFooterView = spinner
    }
    
    func hideLazyLoader() {
        // Add delay to display loader properly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.tableView.tableFooterView = nil
        }
    }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath.row)
    }
}

// MARK: - SearchBar Delegate

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        viewModel.search(searchBar.text ?? "")
    }
}
