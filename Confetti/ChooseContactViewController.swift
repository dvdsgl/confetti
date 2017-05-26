//
//  ChooseContactViewController.swift
//  Confetti
//
//  Created by Ian Leatherbury on 5/26/17.
//  Copyright © 2017 confetti. All rights reserved.
//

import Foundation
import UIKit

class ChooseContactViewController : UITableViewController {
    var objects = ["Stu", "David", "Ian"]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = objects[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
}
