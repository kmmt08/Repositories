//
//  MainViewController.swift
//  Repositories
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        viewModel.delegate = self
        viewModel.search("e")
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
