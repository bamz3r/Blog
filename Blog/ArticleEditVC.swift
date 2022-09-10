//
//  ArticleEditVC.swift
//  Blog
//
//  Created by Bambang on 09/09/22.
//

import UIKit
import Alamofire
import AlamofireImage

class ArticleEditVC: UITableViewController {
    var item_id = 0
    
    var onBackHandler:((ArticleEditVC) -> Void)?
    
    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputContent: UITextField!
    
    var isLoading: Bool = false
    
    var item: ArticleModel = ArticleModel()
    
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...")
        
        initNavBarItem()
        
        initRefreshControl()
        getArticle()
        self.title = "Edit Article"
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
                    self.inputTitle.text = self.item.title
                    self.inputContent.text = self.item.content
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
    
    func saveArticle() {
        if !isLoading {
            self.view.showBlurLoader()
            self.isLoading = true
            self.tableView.reloadData()
            
            ApiCall.updateArticle (id: item_id, title: inputTitle.text!, content: inputContent.text!, completion: {(newItem) in
                self.isLoading = false
                self.view.removeBluerLoader()
                self.myRefreshControl.endRefreshing()
                
                if((newItem) != nil) {
                    self.item = newItem!
                    self.backTapped()
                } else {
                    self.view.showBlurErrorView(errortext: "Opps, no data available")
                }
                
                self.tableView.reloadData()
            }, onerror: {error in
                self.isLoading = false
                self.view.removeBluerLoader()
                self.myRefreshControl.endRefreshing()
                self.view.showBlurErrorView(errortext: "No Internet Connection", showreload: true) {
                    self.saveArticle()
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func initNavBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    @objc func backTapped() {
//        self.dismiss(animated: true, completion: nil)
        if (self.onBackHandler != nil) {
            self.onBackHandler!(self)
        }
    }
    
    @objc func saveTapped() {
        saveArticle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
