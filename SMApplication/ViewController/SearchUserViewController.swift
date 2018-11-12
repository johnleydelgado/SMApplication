//
//  SearchUserViewController.swift
//  SMApplication
//
//  Created by Rapha Solution on 11/9/18.
//  Copyright © 2018 Johnley Delgado. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class SearchUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var noresultLabel: UILabel!
    var Usersearch: [UserSearch] = []
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let loading = Loading()
    var searchActive : Bool = false
    var recieverUser = ""
    var recieveName = ""
    
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noresultLabel.isHidden = true
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        showUser()
        
    }
    
    func showUser(){
        UserConstant.refs.root.child("user").observe(.value, with: { snapshot in
            
            //get Data
            for index in snapshot.children{
                let enumeration = index as! DataSnapshot
                if let dict = enumeration.value as? [String: Any]{
                    
                    let name = dict["name"] as! String
                    let photo = dict["photo"] as! String
                    let email = dict["email"] as! String
                    let uid = dict["uid"] as! String
                    self.recieverUser = uid
                    self.recieveName = name
                    self.Usersearch+=[UserSearch(name: name, email: email, photoUrl: photo,recieveUser:self.recieverUser,recieveName:self.recieveName)]
                    self.loading.hideLoading(to_view: self.view)
                    self.tableView.reloadData()
                }
                
            }
            
        })
        
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let txt = searchBar.text{
            self.noresultLabel.isHidden = true
            loading.showLoading(to_view: self.view)
            
            UserConstant.refs.root.child("user").queryOrdered(byChild: "name").queryStarting(atValue: txt).queryEnding(atValue: txt + "\u{f8ff}").observe(.value, with: { snapshot in
                //print(snapshot)
                self.Usersearch.removeAll()
                if snapshot.value is NSNull {
                    self.loading.hideLoading(to_view: self.view)
                    self.noresultLabel.isHidden = false
                    self.tableView.reloadData()
                }
                else{
                    //get Data
                    for index in snapshot.children{
                        let enumeration = index as! DataSnapshot
                        if let dict = enumeration.value as? [String: Any]{
                            
                            let name = dict["name"] as! String
                            let photo = dict["photo"] as! String
                            let email = dict["email"] as! String
                            let uid = dict["uid"] as! String
                            self.recieverUser = uid
                            self.recieveName = name
                            self.Usersearch+=[UserSearch(name: name, email: email, photoUrl: photo,recieveUser:self.recieverUser,recieveName:self.recieveName)]
                            self.loading.hideLoading(to_view: self.view)
                            self.tableView.reloadData()
                        }
                    }
                    // filtering Data
                    //                    self.self.filtered = self.Usersearch[0].name.filter({ (text) -> Bool in
                    //                        let tmp: NSString = text as NSString
                    //                        let range = tmp.range(of: txt, options: NSString.CompareOptions.caseInsensitive)
                    //                        return range.location != NSNotFound
                    //                    })
                    //                    if(self.filtered.count == 0){
                    //                        self.searchActive = false;
                    //                    } else {
                    //                        self.searchActive = true;
                    //                    }
                    
                }
            })
        }
        
        searchActive = false
        view.endEditing(true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return Usersearch.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ItemSelectedx = indexPath.item
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        let recievename = Usersearch[ItemSelectedx].recieveName
        let recieveuser = Usersearch[ItemSelectedx].recieveUser
        
        self.recieverUser = recieveuser
        self.recieveName = recievename
        
        //print(ItemSelectedx)
        performSegue(withIdentifier: "message", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        if(searchActive == true){
            //cell.textLabel?.text = filtered[indexPath.row]
            self.tableView.isHidden = true
            
            let user = Usersearch[indexPath.row]
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: NSURL(string: user.photoUrl) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
                print(recieved,expected)
            }, completed: { (image, data, error, true) in
                print("Completed")
                //print(image)
                if image != nil {
                    cell.imageView?.image = image
                    cell.textLabel?.text = user.name
                    cell.detailTextLabel?.text = user.email
                    self.loading.hideLoading(to_view: self.view)
                    self.tableView.isHidden = false
                }
            })
        } else {
            self.tableView.isHidden = true
            
            let user = Usersearch[indexPath.row]
            loading.showLoading(to_view: self.view)
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: NSURL(string: user.photoUrl) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
                //print(recieved,expected)
            }, completed: { (image, data, error, true) in
                print("Completed")
                
                self.tableView.isHidden = false
                
                //print(image)
                if image != nil {
                    cell.imageView?.image = image
                    cell.textLabel?.text = user.name
                    cell.detailTextLabel?.text = user.email
                    self.loading.hideLoading(to_view: self.view)
                    
                }
                
            })
            
            
        }
        
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        //Back btn
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segueName == "message"{
            if let destViewController = segue.destination as? MessageViewController
            {
                destViewController.recieverUser = recieverUser
                destViewController.recieveName = recieveName
                // destViewController.membershipImagenumber = imageNumber
            }
        }
        
    }
}
