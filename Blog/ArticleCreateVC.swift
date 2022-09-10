//
//  ArticleCreateVC.swift
//  Blog
//
//  Created by Bambang on 09/09/22.
//

import UIKit
import Alamofire
import AlamofireImage

class ArticleCreateVC: UITableViewController {
    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var inputContent: UITextField!
    
    var onBackHandler:((ArticleCreateVC) -> Void)?
    
    var isLoading: Bool = false
    
    var item: ArticleModel = ArticleModel()
    
    private let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad...")
        
        initNavBarItem()
        self.title = "Create Article"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func saveArticle() {
        if !isLoading {
            self.view.showBlurLoader()
            self.isLoading = true
            self.tableView.reloadData()
            
            ApiCall.createArticle (title: inputTitle.text!, content: inputContent.text!, completion: {(newItem) in
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
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
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

