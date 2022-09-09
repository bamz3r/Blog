//
//  ViewController.swift
//  Blog
//
//  Created by Bambang on 08/09/22.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UITableViewController {
    
    var isLoading: Bool = false
    
    var keyword: String = ""
    
    var items: [ArticleModel] = []
    var currenPage = 1
    var totalPage = 1
    
    var isFirst: Bool = true
    
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...")
        
        initNavBarItem()
        
        initRefreshControl()
        getArticles()
    }
    
    func initRefreshControl() {
        self.myRefreshControl.tintColor = UIColor.gray
        self.myRefreshControl.addTarget(self, action: #selector(self.refreshMainData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = self.myRefreshControl
        } else {
            tableView.addSubview(self.myRefreshControl)
        }
    }
    
    @objc func refreshMainData() {
        self.currenPage = 1
        self.getArticles()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt tableView \(indexPath.row)")
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt tableView \(indexPath.row)")
        
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "article_cell", for: indexPath) as! ArticleCell
        cell.displayContent(item: item)
        cell.tag = indexPath.row
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row > 1) {
            print("didSelectRowAt tableList")
        performSegue(withIdentifier: "article_to_detail", sender: indexPath.row)
        
//        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.items.count-1 {
            if(self.totalPage > self.currenPage && !self.isLoading) {
              print("Begin next page")
              self.currenPage += 1
              self.getArticles()
          }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("sender \(String(describing: sender))")
        if(segue.identifier == "article_to_detail") {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! ArticleDetailVC
            
//            if let cell = sender as? ArticleCell
//            {
//                let indexPath = cell.tag
                // use indexPath :D
            svc.item_id = self.items[sender as! Int].id;
            print("sender \(svc.item_id)")
//            }
        } else if(segue.identifier == "article_to_create") {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! ArticleDetailVC
            
            if let cell = sender as? ArticleCell
            {
                let indexPath = cell.tag
                // use indexPath :D
                svc.item_id = self.items[indexPath].id;
            }
        }
    }
    
    func getArticles() {
        if !isLoading {
            if currenPage > 1 {
//                self.aiLoading.show()
            } else {
                self.view.showBlurLoader()
            }
            self.isLoading = true
            if(currenPage == 1 && !isFirst) {
                items.removeAll()
                self.tableView.reloadData()
            }
            isFirst = false;
            
            ApiCall.getArticles (page: currenPage, completion: {(newItems) in
                self.isLoading = false
                self.view.removeBluerLoader()
                self.myRefreshControl.endRefreshing()
                
                if(newItems!.count > 0) {
                    self.items.append(contentsOf: newItems!)
                } else {
                    if(self.currenPage == 1) {
                        self.view.showBlurErrorView(errortext: "Opps, no data available")
                    }
                }
                
                self.tableView.reloadData()
            }, onerror: {error in
                self.isLoading = false
                self.view.removeBluerLoader()
                self.myRefreshControl.endRefreshing()
                self.view.showBlurErrorView(errortext: "No Internet Connection", showreload: true) {
                    self.getArticles()
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func initNavBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_top_filter_white"), style: .plain, target: self, action: #selector(filterTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func filterTapped() {
        performSegue(withIdentifier: "search_to_filter", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

func formatDate(strDate: String) -> String {
    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .full
    let date = dateFormatter.date(from: strDate) ?? Date()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
    return dateFormatter.string(from: date)
}

class ArticleCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelPublished: UILabel!
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelupdated: UILabel!
    
    var cellItem: ArticleModel = ArticleModel()
    
    func displayContent(item: ArticleModel) {
        cellItem = item
        labelTitle.text = cellItem.title
        labelTitle.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
//        labelContent.text = cellItem.content
        labelPublished.text = formatDate(strDate: cellItem.published_at)
//        labelCreated.text = cellItem.created_at
//        labelupdated.text = cellItem.updated_at
    }
}






