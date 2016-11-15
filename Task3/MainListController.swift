//
//  ViewController.swift
//  Locator
//
//  Created by Vedad Hasanagic on 11/11/16.
//  Copyright © 2016 VEdad H. All rights reserved.
//

import UIKit
import Unbox

class MainListController: UITableViewController {
    
    @IBOutlet weak var stepper: UIStepper!

    var peopleList: [Person]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PeopleService.service.fetchAll { [unowned self] (people) in
            self.peopleList = people.filter{ ($0.location?.distanceKiloMeters(SphericalCoordinates.DublinOffice) ?? 101.0) <= 100.0 }.sorted(by: { (p1, p2) -> Bool in
                return p1.userId <= p2.userId ? true : false
            })
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonDetailCell") as! PersonDetailCell

        cell.render(person: peopleList[indexPath.row])
        return cell
    }


}

