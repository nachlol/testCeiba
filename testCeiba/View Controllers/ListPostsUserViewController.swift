//
//  ListPostsUserViewController.swift
//  testCeiba
//
//  Created by Nicolas Chavez on 10/21/20.
//  Copyright © 2020 Nicolas Chavez. All rights reserved.
//

import UIKit

class ListPostsUserViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    @IBOutlet weak var collectionPosts:UICollectionView!
    
    var user:User?
    var postsUser:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = self.user {
            lblName.text = user.name
            lblEmail.text = user.email
            lblPhone.text = user.phone
        }
    }
    
    //MARK: Actions
    
    @IBAction func closePost(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: Collection Post Delegate and Datasource

extension ListPostsUserViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPost", for: indexPath) as! PostsCollectionViewCell
        cell.layer.applySketchShadow(
        color: .black,
        alpha: 0.5,
        x: 0,
        y: 0,
        blur: 4,
        spread: 0)
        cell.layer.masksToBounds = false
        cell.lblTitle.text = self.postsUser[indexPath.row].title
        cell.lblBody.text = self.postsUser[indexPath.row].body
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width

        let yourWidthOfLable = self.collectionPosts.frame.size.width
        let expectedHeightBody = heightForLable(text: self.postsUser[indexPath.row].body, width: yourWidthOfLable-36)   // Margin left 20 || right 16 Constraints
        let expectedHeighttitle = heightForLable(text: self.postsUser[indexPath.row].title, width: yourWidthOfLable-36) // Margin left 20 || right 16 Constraints
        return CGSize(width: screenWidth-26, height: expectedHeighttitle+expectedHeightBody+10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    //MARK: Calculated Height
    
    func heightForLable(text:String, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
         label.numberOfLines = 0
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         label.text = text
         label.sizeToFit()
         return label.frame.height
    }
}


//MARK: - Shadows

extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
