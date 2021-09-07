//
//  ListViewController.swift
//  OmdbMovieApp
//
//  Created by bora on 2.09.2021.
//

import UIKit
import Kingfisher
import MBProgressHUD

class ListViewController: UIViewController {
    
    let service = Services()
    var searchTimer: Timer?
    let screen = UIScreen.main.bounds
    var searchResults: [Search]? = []
    var movieList: [Search]? = []
    var page = "1"
    public static var movieListModel: SearchResultsModel?
    var presenter: ListPresenterProtocol!

    private lazy var tableviewOfMovieList: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MovieListCell.self, forCellReuseIdentifier: "movieList")
        return tableview
    }()
    
    private lazy var tableViewOfSearchBar: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        tableView.alpha = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.setValue("Cancel", forKey: "cancelButtonText")
        searchBar.placeholder = "Search Movies"
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.layout()
        getMovieList()
    }
    
    private func getMovieList() {
        self.showHUD(progressLabel: "")
        tableviewOfMovieList.isHidden = true
        service.getMovieList(pagination: false, page: page) { [weak self] (response) in
            print(response)
            ListViewController.movieListModel = response
            self?.movieList = response.search
            DispatchQueue.main.async {
                self?.tableviewOfMovieList.reloadData()
            }
            self?.tableviewOfMovieList.isHidden = false
            self?.dismissHUD(isAnimated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.titleView = searchBar
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
    }
    
    @objc func refresh() {
        self.tableviewOfMovieList.reloadData()
        // a refresh the tableView.
    }
    
    private func loadingInducator(isVisible: Bool) {
        isVisible ? LoadingView.shared.show() : LoadingView.shared.hide()
    }
    
}

//MARK: Layout
extension ListViewController {
    
    private func layout() {
        
        view.backgroundColor = .white
        view.addSubview(tableviewOfMovieList)
        tableviewOfMovieList.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(tableViewOfSearchBar)
        tableViewOfSearchBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        tableviewOfMovieList.tableFooterView = UIView()
        
    }
    
    private func tableViewOfSearchBar(isVisiable: Bool) {
        isVisiable ? (tableViewOfSearchBar.isHidden = !isVisiable) : nil
        UIView.animate(withDuration: 0.3) {
            self.tableViewOfSearchBar.alpha = isVisiable ? 1 : 0
        } completion: { [unowned self]_ in
            isVisiable ? nil : (self.tableViewOfSearchBar.isHidden = !isVisiable)
        }
    }
    
}

//MARK: UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(searchBar: searchBar ,isEditing: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar(searchBar: searchBar, isEditing: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // presenter.searchedMovie(movieName: searchText)
        let queryText = searchText.trimmingCharacters(in: .whitespaces)

        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.searchTimer?.invalidate()
            self.searchTimer = nil
            if queryText != "" && queryText.count > 2 {
                self.service.getSearchMovieResults(params: queryText) { [weak self] (response) in
                    print(response)
                    if response.search?.count ?? 0 > 0 {
                        self?.searchResults = response.search
                        DispatchQueue.main.async {
                            self?.tableViewOfSearchBar.reloadData()
                        }
                    }
                    else {
                        print("error data cant read")
                    }
                }
                
            }
        })
       
    }
    
    private func searchBar(searchBar: UISearchBar, isEditing: Bool) {
        searchBar.showsCancelButton = isEditing
        _ = isEditing ? searchBar.becomeFirstResponder() :  searchBar.endEditing(true)
        tableViewOfSearchBar(isVisiable: isEditing)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let movieListCount = ListViewController.movieListModel?.search?.count ?? 0
            return tableView == tableviewOfMovieList ? movieListCount : (searchResults?.count ?? 0)
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableviewOfMovieList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieList", for: indexPath) as! MovieListCell
            cell.accessoryType = .disclosureIndicator
            guard let movieList = ListViewController.movieListModel?.search?[indexPath.row] else {
                return UITableViewCell()
            }
            cell.setCell(movie: movieList)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            guard let movie = searchResults?[indexPath.row] else { return UITableViewCell()}
            cell.textLabel?.text = movie.title
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableviewOfMovieList {
            return 100
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableviewOfMovieList.deselectRow(at: indexPath, animated: true)
        tableViewOfSearchBar.deselectRow(at: indexPath, animated: true)
        if tableView == tableviewOfMovieList {
            let id = ListViewController.movieListModel?.search?[indexPath.row].imdbID ?? ""
            self.loadingInducator(isVisible: true)
            let vc = DetailRouter().prepareView(movieID: id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if tableView == tableViewOfSearchBar {
            guard let movie = searchResults?[indexPath.row] else { return }
            let vc = DetailRouter().prepareView(movieID: movie.imdbID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableviewOfMovieList.contentSize.height - 100 - scrollView.frame.size.height) {
            // print("fetch more")
            
            guard !service.isPaginating else {
                return
            }
            
            tableviewOfMovieList.tableFooterView = createSpinnerFooter()

            let pageInt = (Int(self.page) ?? 1 ) + 1
            let pageS = String(pageInt)
            self.page = pageS
            
            print(pageS)
            
            service.getMovieList(pagination: true, page: pageS) { [weak self] (response) in
                if response.search?.count == 0 {
                    let pageInt = (Int(self?.page ?? "1") ?? 1 ) - 1
                    let pageS = String(pageInt)
                    self?.page = pageS
                }
                if response.search?.isEmpty == false {
                    ListViewController.movieListModel?.search?.append(contentsOf: response.search ?? [])
                    
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "newDataNotif"),object: nil))
                    DispatchQueue.main.async {
                        self?.tableviewOfMovieList.reloadData()
                    }
                }
            }
            
        }
    }
    
}

