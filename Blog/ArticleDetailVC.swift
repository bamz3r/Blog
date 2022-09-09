//
//  ArticleDetailVC.swift
//  Blog
//
//  Created by Bambang on 08/09/22.
//

import UIKit
import Alamofire
import AlamofireImage

class ArticleDetailVC: UITableViewController {
    var item_id = 0
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var labelPublished: UILabel!
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelUpdated: UILabel!
    
    var isLoading: Bool = false
    
    var item: ArticleModel = ArticleModel()
    
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...")
        
        initNavBarItem()
        
        initRefreshControl()
        getArticle()
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
        self.getArticle()
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt tableView \(indexPath.row)")
        return self.table
    }*/
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt tableView \(indexPath.row)")
        
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "article_cell", for: indexPath) as! ArticleCell
        cell.displayContent(item: item)
        cell.tag = indexPath.row
        return cell
    }*/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row > 1) {
            print("didSelectRowAt tableList")
            performSegue(withIdentifier: "article_to_detail", sender: indexPath)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detail_to_edit") {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! ArticleDetailVC
            if let cell = sender as? ArticleCell
            {
                let indexPath = cell.tag
                // use indexPath :D
                svc.item_id = self.item_id;
            }
        }
    }
    
    func getArticle() {
        if !isLoading {
            self.view.showBlurLoader()
            self.isLoading = true
            self.tableView.reloadData()
            
            ApiCall.getArticleDetail (id: item_id, completion: {(newItem) in
                self.isLoading = false
                self.view.removeBluerLoader()
                self.myRefreshControl.endRefreshing()
                
                if((newItem) != nil) {
                    self.item = newItem!
                    self.labelTitle.text = self.item.title
                    self.labelContent.text = self.item.content
                    self.labelPublished.text = self.item.published_at
                    self.labelCreated.text = self.item.created_at
                    self.labelUpdated.text = self.item.updated_at
                } else {
                    self.view.showBlurErrorView(errortext: "Opps, no data available")
                }
                
                self.tableView.reloadData()
            }, onerror: {error in
                self.isLoading = false
                self.view.removeBluerLoader()
                self.myRefreshControl.endRefreshing()
                self.view.showBlurErrorView(errortext: "No Internet Connection", showreload: true) {
                    self.getArticle()
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func initNavBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(backTapped))
        let button1  = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        let button2 = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped))
        self.navigationItem.rightBarButtonItems = [button1, button2]
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editTapped() {
        performSegue(withIdentifier: "detail_to_edit", sender: self)
    }
    
    @objc func deleteTapped() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
