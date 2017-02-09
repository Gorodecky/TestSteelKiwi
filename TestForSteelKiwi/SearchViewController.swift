//
//  SearchViewController.swift
//  TestForSteelKiwi
//
//  Created by Mac on 07.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CCBottomRefreshControl
import SVProgressHUD

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    let refreshControl = UIRefreshControl()
    var totalCountPagesInResponse :Int?
    var pageCount = 1
    
    let searchCellIdentifier = "searchViewCellIdentifier"
    var arrayResultSearching = [RepositorySearch]()
    
    @IBOutlet weak var searchBarGitRepository: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.triggerVerticalOffset = 100
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView.bottomRefreshControl = refreshControl
    }
    
    func refresh() {
        
        while self.pageCount != self.totalCountPagesInResponse {
            self.pageCount = self.pageCount + 1
            self.search()
            //print("REFRESH")
            self.tableView.bottomRefreshControl?.endRefreshing()
            return
            
        }
        self.tableView.bottomRefreshControl?.endRefreshing()
        print("End!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: UISearchBarDelegate
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarGitRepository.endEditing(true)
        self.searchBarGitRepository.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrayResultSearching.removeAll()
        self.searchBarGitRepository.text = ""
        self.tableView.reloadData()
        self.searchBarGitRepository.resignFirstResponder()
        self.totalCountPagesInResponse = nil
        self.pageCount = 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarGitRepository.endEditing(true)
        self.search()
    }
    
    //MARK: call JSON
    func search() {
        
        if (self.searchBarGitRepository.text?.characters.count)! > 0 {
            
            let searchRequest = self.searchBarGitRepository.text as String!
            self.requestToGit(searchRequest: searchRequest!, pageCount: self.pageCount)
            
        } else {
            return
        }
    }
    
    func requestToGit(searchRequest:String, pageCount count:Int) {
        
        let parameters:Parameters = ["q":"\(searchRequest)",
                                    "sort":"stars",
                                    "order":"desc",
                                    "page":"\(count)"]
        
        Alamofire.request("https://api.github.com/search/repositories", method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success:
                //print("value \(response.value)")
                self.processingResponse(data: response.data! as Data)
                
            case .failure(let error):
                print("Response \(error)")
            }
        }
    }
    
    func processingResponse(data: Data) {
        
        let json = JSON(data: data)
        
        if let totalCount = json["total_count"].int {
            
            if self.totalCountPagesInResponse == nil {
                self.totalCountPagesInResponse = totalCount / 30
            }
            
            if totalCount > 0 {
                
                let items = json["items"].arrayObject
                
                for item in items! {
                    
                    let repoJSON = JSON(item)
                    let name = repoJSON["name"].string
                    let desc = repoJSON["description"].string
                    let author = repoJSON["owner"]["login"].string
                    
                    let repo = RepositorySearch(nameRepo: name!,
                                                descriptionRepo: desc,
                                                authorRepo: author!)
                    
                    self.arrayResultSearching.append(repo)
                }
                
                self.tableView.reloadData()
                
            } else {
                print("Items count nil!! Search rezult may bee nil")
                
                self.searchBarGitRepository.text = "Search result is nil!!!"
                self.arrayResultSearching.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayResultSearching.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier, for: indexPath) as!SearchViewTableViewCell
        
        cell.initialyCell(repository: self.arrayResultSearching[indexPath.row])
        
        return cell
    }
}
