import UIKit
import ConfettiKit

import Firebase

import FRStretchImageView

class MasterViewController: UITableViewController {

    @IBOutlet weak var heroImage: FRStretchImageView!    
    @IBOutlet var pillView: CountdownPillView!
    
    var detailViewController: DetailViewController? = nil
    var viewModels = [EventViewModel]()
    var registrations = [NotificationRegistration]()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.isNavigationBarHidden = true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onEventsChanged = UserViewModel.current.onEventsChanged {
            self.updateWith(events: $0)
        }
        registrations.append(onEventsChanged)
        
        // Setting FRStretchImageView
        heroImage.stretchHeightWhenPulledBy(scrollView: tableView)
    }
    
    deinit {
        registrations.forEach { $0.removeObserver() }
    }
    
    func updateWith(events: [Event]) {
        viewModels = events
                        .map { EventViewModel.fromEvent($0) }
                        .sorted(by: { $0.daysAway < $1.daysAway })
        
        if let hero = viewModels.first {
            if let photoUrl = hero.person.photoUrl {
                heroImage.sd_setImage(with: URL(string: photoUrl))
            }
            
            pillView.setEvent(hero)
        }
        
        if let hero = viewModels.first {
            if let photoUrl = hero.person.photoUrl {
                heroImage.sd_setImage(with: URL(string: photoUrl))
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDetail":
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = viewModels[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        case "newEvent":
            return
        default:
            return
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        let event = viewModels[indexPath.row]
        cell.setEvent(event)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(EventTableViewCell.defaultHeight);
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let viewModel = viewModels[indexPath.row]
            UserViewModel.current.deleteEvent(viewModel.event)
        default:
            return
        }
    }
}

