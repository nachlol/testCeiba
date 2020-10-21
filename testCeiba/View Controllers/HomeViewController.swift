//
//  HomeViewController.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/20/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableUsers: UITableView!
    @IBOutlet weak var txtfdSearch: UITextField!
    
    let baseUrl = "https://jsonplaceholder.typicode.com"
    var users:[User] = []
    var tempUser:[User] = []
    var postsUser:[Post] = []
    var userSelected:User?

    var activity = UIActivityIndicatorView(style: .large)
    let localStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if let sessionInfo = localStorage.value(forKey:"SavedUser") as? Data {
            let localUserInfo = try! PropertyListDecoder().decode([User].self, from: sessionInfo)
            self.users = localUserInfo
            self.tempUser = self.users
        }else {
            getCategories()
        }
    }
    
    //MARK: Actions
    
    @IBAction func findUser(_ sender:Any){
        if txtfdSearch.text! == ""{
            alert(message: "Empty Field", title: "Message")
        }
    }
    
    @IBAction func searchTextfield(textField: UITextField) {
       if textField == txtfdSearch {
           self.users.removeAll()
           if textField.text?.count != 0{
               for user in tempUser {
                   if let restaurantSearch = textField.text {
                       let range = user.name.lowercased().range(of: restaurantSearch, options: .caseInsensitive, range: nil, locale: nil)
                       if range != nil {
                           self.users.append(user)
                       }
                   }
               }
           }else{
               for user in tempUser {
                   self.users.append(user)
               }
           }
           self.tableUsers.reloadData()
       }
    }
    
    
    //MARK: Functions
    
    func alert(message:String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func config(){
        txtfdSearch.setPadding(width: 10)
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerYAnchor.constraint(equalTo: tableUsers.centerYAnchor,constant: 60).isActive = true
        activity.centerXAnchor.constraint(equalTo: tableUsers.centerXAnchor).isActive = true
    }
    
    //MARK: Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == ""{
            self.alert(message: "empty fields", title: "Message")
        }else {
            print("search")
        }
        view.endEditing(true)
        return true
    }
    
    //MARK: Call Api
    
    func getCategories(){
        self.activity.startAnimating()
        let jsonUrlstring = "\(baseUrl)/users"
        guard let url = URL(string: jsonUrlstring) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            defer {
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                }
            }
            if err != nil {
                DispatchQueue.main.async {
                    if let error = err {
                        self.tableUsers.setEmptyMessage("\(error.localizedDescription)")
                    }
                }
            }
            guard let data = data else {return}
            do {
                self.users = try JSONDecoder().decode([User].self, from: data)
                self.tempUser = self.users
                DispatchQueue.main.async {
                    self.tableUsers.reloadData()
                    if self.users.count == 0 {
                        self.tableUsers.setEmptyMessage("Users not Found!")
                    } else {
                        self.localStorage.set(try? PropertyListEncoder().encode(self.users),forKey: "SavedUser")
                        self.tableUsers.restore()
                    }
                }
            } catch let jsonErr {
                 DispatchQueue.main.async {
                    self.tableUsers.setEmptyMessage("\(jsonErr.localizedDescription)")
                }
            }
        }.resume()
    }
    
    
    func getPostUser(userId:Int){
        self.activity.startAnimating()
        let jsonUrlstring = "\(baseUrl)/posts?userId=\(userId)"
        guard let url = URL(string: jsonUrlstring) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err) in
            defer {
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                }
            }
            if err != nil {
                DispatchQueue.main.async {
                    if let error = err {
                        self.alert(message: "\(error.localizedDescription)", title: "Error")
                    }
                }
            }
            guard let data = data else {return}
            do {
                self.postsUser = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                   self.performSegue(withIdentifier: "seguePosts", sender: nil)
                }
            } catch let jsonErr {
                 DispatchQueue.main.async {
                    self.alert(message: "\(jsonErr.localizedDescription)", title: "Error")
                }
            }
        }.resume()
    }
    
    //MARK: Segue
       
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "seguePosts" {
           let destinationNavigationController = segue.destination as! UINavigationController
           let targetController = destinationNavigationController.topViewController
           let vc = targetController as! ListPostsUserViewController
            vc.user = self.userSelected
            vc.postsUser = self.postsUser
       }
   }
}

//MARK: - Configuration Table Users

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
            self.tableUsers.setEmptyMessage("List is empty")
        }else {
            self.tableUsers.restore()
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "ContentUsers", bundle: nil), forCellReuseIdentifier: "cellContent")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContent") as! ContentUsersTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configure(with: users[indexPath.row].id, index: indexPath)
        cell.lblName.text = users[indexPath.row].name
        cell.lblPhone.text = users[indexPath.row].phone
        cell.lblEmail.text = users[indexPath.row].email
        return cell
    }
}

//MARK: Get ID User

extension HomeViewController: TablePostCellDelegate {
    
    func didTapPost(with userId: Int, index: Int) {
        self.userSelected = self.users[index]
        self.getPostUser(userId: userId)
    }
}
