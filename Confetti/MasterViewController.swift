import UIKit
import ConfettiKit

import Firebase

import FRStretchImageView

class MasterViewController: UITableViewController {

    @IBOutlet weak var heroImage: FRStretchImageView!
    
    var detailViewController: DetailViewController? = nil
    
    var events = [EventViewModel]()
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
        let viewModels = events.map { EventViewModel.fromEvent($0) }
        self.events = viewModels.sorted(by: { $0.daysAway < $1.daysAway })
        
        if let hero = events.first {
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
                let object = events[indexPath.row]
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
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
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
            let viewModel = events[indexPath.row]
            UserViewModel.current.deleteEvent(viewModel.event)
        default:
            return
        }
    }
}

