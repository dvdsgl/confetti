import UIKit
import ConfettiKit

import Firebase

extension UIViewController {
    func styleTransparentNavigationBar() {
        // Get rid of nav bar shadow for a nice, continuous look
        guard let bar = navigationController?.navigationBar else { return }
        
        bar.shadowImage = UIImage()
        bar.setBackgroundImage(UIImage(), for: .default)
        bar.isTranslucent = true
    }
}

class EventListViewController: UITableViewController, HeroStretchable {
    
    @IBOutlet var heroView: HeroView!
    
    var viewModels = [EventViewModel]()
    var registrations = [NotificationRegistration]()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleTransparentNavigationBar()
        setupStretchyHero()
        
        let onEventsChanged = UserViewModel.current.onEventsChanged {
            self.updateWith(events: $0)
        }
        registrations.append(onEventsChanged)        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateStretchyHero()
    }
    
    deinit {
        registrations.forEach { $0.removeObserver() }
    }
    
    func updateWith(events: [Event]) {
        viewModels = events
                        .map { EventViewModel.fromEvent($0) }
                        .sorted(by: { $0.daysAway < $1.daysAway })
        
        if let hero = viewModels.first {            
            heroView.setEvent(hero)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDetail":
            let controller = segue.destination as! EventDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.event = viewModels[indexPath.row]
            }
        default:
            return
        }
    }

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

