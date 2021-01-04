//
//  UsersTableViewController.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 04.01.2021.
//

import UIKit
import Alamofire

class UsersTableViewController: UITableViewController {

    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        NetworkClient.request(Router.users).responseDecodable { (response: AFDataResponse<Users>) in
            switch response.result {
            case .success(let value):
                self.users = value
            case .failure(let error):
              let isServerTrustEvaluationError =
                error.asAFError?.isServerTrustEvaluationError ?? false
              let message: String
              if isServerTrustEvaluationError {
                message = "Certificate Pinning Error"
              } else {
                message = error.localizedDescription
              }
                print(response.result)
              self.presentError(withTitle: "Oops!", message: message)
            }
          }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! UserTableViewCell

        let user = users[indexPath.item]
        
        return cell.configureCell(user: user)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

extension UsersTableViewController {
  func presentError(withTitle title: String,
                    message: String,
                    actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    actions.forEach { action in
      alertController.addAction(action)
    }
    present(alertController, animated: true)
  }
}