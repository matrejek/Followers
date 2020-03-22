//
//  Created by Mateusz Matrejek
//

import UIKit
import GithubAPI
import GithubFoundation

protocol FollowersViewControllerDelegate: AnyObject {
    func followersViewController(_ controller: FollowersViewController, didSelect follower: String)
    func followersViewControllerDidRequestFetchingFollowers(_ controller: FollowersViewController)
    func followersViewController(_ controller: FollowersViewController, didToggleFavourite user: String)
}

class FollowersViewController: UIViewController {

    struct ViewModel: Hashable {

        let username: String

        let avatarURL: URL?

        init(_ model: Follower) {
            username = model.login
            avatarURL = URL(string: model.avatarUrl)
        }
    }

    var username: String = "" {
        didSet {
            self.title = username
        }
    }

    weak var delegate: FollowersViewControllerDelegate?

    var followers: [ViewModel] = [] {
        didSet {
            if followers.isEmpty {
                let message = "This user doesn't have any followers. Go follow them 😀."
                DispatchQueue.main.async { self.showEmptyStateView(with: message) }
                return
            }
            DispatchQueue.main.async { self.dismissEmptyStateView() }
            updateDataSource(with: followers)
        }
    }

    private enum Section { case main }

    private var filteredFollowers: [ViewModel] = []

    private var collectionView: UICollectionView!

    private var isSearching = false

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, ViewModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
        let reuseId = UserCell.reuseId
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId,
                                                      for: indexPath) as! UserCell
        cell.setup(with: follower)
        return cell
    })

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.username = ""
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        collectionView.dataSource = dataSource
    }

    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("Search for a username", comment: "search_prompt")
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func updateDataSource(with followers: [ViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    @objc
    private func addButtonTapped() {
        delegate?.followersViewController(self, didToggleFavourite: username)
    }

}

extension FollowersViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.username.lowercased().contains(filter.lowercased()) }
        updateDataSource(with: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateDataSource(with: followers)
    }
}

extension FollowersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let username = (isSearching ? filteredFollowers : followers)[indexPath.item].username
        delegate?.followersViewController(self, didSelect: username)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            delegate?.followersViewControllerDidRequestFetchingFollowers(self)
        }
    }
}
