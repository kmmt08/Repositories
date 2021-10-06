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
        navigationController?.setToDefault()
        tableView.register(UINib(nibName: String(describing: ListTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.register(UINib(nibName: String(describing: ErrorTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: ErrorTableViewCell.identifier)
    }
    
}

// MARK: - MainViewModel Protocol

extension MainViewController: MainViewModelProtocol {
    func reloadTableView(scrollToTop: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if scrollToTop {
                self.tableView.scrollToRow(at: .init(row: 0, section: 0),
                                           at: .top,
                                           animated: true)
            }
        }
    }
    
    func showLazyLoader() {
        DispatchQueue.main.async {
            let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            spinner.frame = .init(x: 0,
                                  y: 0,
                                  width: self.tableView.bounds.width,
                                  height: 44)
            spinner.startAnimating()
            self.tableView.tableFooterView = spinner
        }
    }
    
    func hideLazyLoader() {
        // Add delay to display loader properly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
            self?.tableView.tableFooterView = nil
        }
    }
    
    func showFullLoader() {
        Loader.shared.show()
    }
    
    func hideFullLoader() {
        Loader.shared.hide()
    }
}

// MARK: - TableView DataSource/Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.tableCellData {
        case .blank:
            return 0
        case .error:
            return 1
        case .success(let items):
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.tableCellData {
        case .blank:
            return UITableViewCell()
        case .success(let items):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
                return UITableViewCell()
            }
            cell.displayData(items[indexPath.row])
            return cell
        case .error(let message):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.identifier, for: indexPath) as? ErrorTableViewCell else {
                return UITableViewCell()
            }
            cell.setErrorMessage(message)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.tableCellData {
        case .blank, .error:
            return tableView.frame.height
        case .success:
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 0,
           presentedViewController as? UIAlertController == nil {
            viewModel.didScrollAtEnd()
        }
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
        viewModel.didSelectCell(at: indexPath.row)
    }
    
    private func dismissKeyboard() {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

// MARK: - SearchBar Delegate

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        viewModel.search(searchBar.text ?? "")
    }
}
