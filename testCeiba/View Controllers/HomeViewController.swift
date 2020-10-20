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
    var activity = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCategories()
    }
    
    //MARK: Actions
    
    @IBAction func findUser(_ sender:Any){
        if txtfdSearch.text! == ""{
            alert(message: "Empty Field", title: "Message")
        }else {
            print("search")
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
                print(self.users)
                DispatchQueue.main.async {
                    self.tableUsers.reloadData()
                    if self.users.count == 0 {
                        self.tableUsers.setEmptyMessage("Users not Found!")
                    } else {
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
        cell.lblName.text = users[indexPath.row].name
        cell.lblPhone.text = users[indexPath.row].phone
        cell.lblEmail.text = users[indexPath.row].email
        return cell
    }
    
}
