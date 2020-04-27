//
//  ViewController.swift
//  coronavirus
//
//  Created by PRABALJIT WALIA     on 20/04/20.
//  Copyright © 2020 PRABALJIT WALIA    . All rights reserved.
//


import Firebase
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableview: UITableView!
    
    var articles: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MISTAKE 1
        tableview.delegate = self
        tableview.dataSource = self
        
        FirebaseApp.configure()

        
        fetchArticles()
    }
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=8c9ab805acd4430c8be56555459bc4f9")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
        
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    print(articlesFromJson)
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                    
                            
                            article.desc = desc
                            article.headline = title
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            } catch let error {
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MISTAKE 2 - HERE YOU ARE USING "ArticleCell" AS IDENTIFIER BUT YOU DID'NT NAME IT AS REUSABLE IDENTIFIER
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        cell.title.text = self.articles?[indexPath.item].headline
        cell.desc.text = self.articles?[indexPath.item].desc
        
//        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }

}

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}








