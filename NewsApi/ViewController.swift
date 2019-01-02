//
//  ViewController.swift
//  NewsApi
//
//  Created by Dhawal Mahajan on 22/12/18.
//  Copyright © 2018 Dhawal Mahajan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var source = "techcrunch"
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(fromSource: source)
    }
    
    func fetchData(fromSource provider: String) {
        articles = [Article]()
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(provider)&apiKey=f93ed75221804c30888efdbda9aee7b1&sortedBy=top")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error! )
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any] else { return }
                if let articlesFromJson = json["articles"] as? [[String : Any]] {
                    for article in articlesFromJson {
                        if let title = article["title"] as? String, let subtitle = article["description"] as? String, let url = article["url"] as? String, let profileImgUrl = article["urlToImage"] as? String, let author = article["author"] as? String {
                            let art = Article()
                            art.title = title
                            art.description = subtitle
                            art.imageUrl = profileImgUrl
                            art.url = url
                            art.author = author
                            self.articles.append(art)
                        }
                    }
                    
                }
                
                
            } catch let error{
                print(error)
            }
        }
        task.resume()
    }
    
    let manager = MenuManager()
    @IBAction func menuTapped(_ sender: UIBarButtonItem) {
        manager.openMenu()
        manager.mainVC = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        cell.titleLabel.text = articles[indexPath.row].title
        cell.subtitleLabel.text = articles[indexPath.row].description
        cell.authorLabel.text = articles[indexPath.row].author
        cell.profileImage.downloadImage(from: articles[indexPath.row].imageUrl!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebVC") as! WebVC
        webVc.url = articles[indexPath.item].url
        self.present(webVc, animated: true, completion: nil)
    }
}

extension UIImageView {
    func downloadImage(from url: String) {
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error! )
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
}
