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
    
    var onBackHandler:((ArticleDetailVC) -> Void)?
    
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
        self.title = "Read Article"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detail_to_edit") {
            let nav = segue.destination as! UINavigationController
            if let svc = nav.topViewController as? ArticleEditVC {
                svc.item_id = self.item_id
                svc.onBackHandler = {(senderVC) in
                
                    self.getArticle()
                    senderVC.dismiss(animated: true, completion: nil)
                }
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
    
    func deleteArticle() {
        if !isLoading {
            self.view.showBlurLoader()
            self.isLoading = true
            self.tableView.reloadData()
            
            ApiCall.deleteArticle (id: item_id, title: self.item.title, content: self.item.content, completion: {(newItem) in
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
                    self.deleteArticle()
                }
                self.tableView.reloadData()
            })
        }
    }
   
    @objc func backTapped() {
//        self.dismiss(animated: true, completion: nil)
        if (self.onBackHandler != nil) {
            self.onBackHandler!(self)
        }
    }
    
    @objc func editTapped() {
        performSegue(withIdentifier: "detail_to_edit", sender: self)
    }
    
    @objc func deleteTapped() {
        let alert = UIAlertController(title: title, message: "Are you sure to delete?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            ApiCall.deleteArticle(id: self.item_id, title: self.item.title, content: self.item.content) { (newItem) in
                self.backTapped()
            } onerror: { (error) in
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
