//
//  Created by Mateusz Matrejek
//

import UIKit

protocol FavouritesListViewControllerDelegate: AnyObject {
    func favouritesController(_ controller: FavouritesListViewController, didRequestFollowers username: String)
    func favouritesController(_ controller: FavouritesListViewController, didRequestDeletion favourite: String)
}

class FavouritesListViewController: UITableViewController {

    weak var delegate: FavouritesListViewControllerDelegate?

    struct ViewModel {
        let username: String
        let avatarURL: URL
    }

    var favourites: [ViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favourites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favourites[indexPath.row]
        delegate?.favouritesController(self, didRequestFollowers: favorite.username)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let favorite = favourites[indexPath.row]
        delegate?.favouritesController(self, didRequestDeletion: favorite.username)
    }
}
