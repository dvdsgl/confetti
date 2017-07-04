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
    @IBOutlet var footerView: UIView!
    @IBOutlet var emptyTableView: UIView!
    
    var viewModels = [EventViewModel]()
    var registrations = [NotificationRegistration]()
    var notificationInfo = [AnyHashable : Any]()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleTransparentNavigationBar()
        setupStretchyHero()
        
        // Remove the label from back button in nav bar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
        
        let onEventsChanged = UserViewModel.current.onEventsChanged {
            self.updateWith(events: $0)
        }
        
        registrations.append(onEventsChanged)
        
        heroView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(heroTapped(_:))))
        
        // Listen for notification
        NotificationCenter.default.addObserver(self, selector: #selector(EventListViewController.performSegueForNotification), name: NSNotification.Name(rawValue: notificationKey), object: nil)
    }
    
    func heroTapped(_ sender: Any) {
        guard let controller: EventDetailViewController = viewController("eventDetail") else {
            return
        }
        controller.event = viewModels.first
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func performSegueForNotification(notification: NSNotification) {
        // Set notification info to find correct event, is called in prepare(for segue: ...)
        notificationInfo = notification.userInfo!
        
        tabBarController?.selectedIndex = 0
        performSegue(withIdentifier: "showDetail", sender: Any?.self)
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
            heroView.event = hero
        }
        
        if viewModels.count == 0 {
            tableView.backgroundView = emptyTableView
            heroView.isHidden = true
            footerView.isHidden = true
        } else {
            tableView.backgroundView = nil
            heroView.isHidden = false
            footerView.isHidden = false            
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDetail":
            let controller = segue.destination as! EventDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.event = viewModels[indexPath.row + 1]
            } else {
                // Handle the case of notifications
                let controller = segue.destination as! EventDetailViewController
                if let eventViewModel = getEventViewModelForNotifation() {
                    controller.event = eventViewModel
                } else { return }
            }
        default:
            return
        }
    }
    
    func getEventViewModelForNotifation() -> EventViewModel? {
        guard let events = UserViewModel.current.events else { return nil }
        let eventKey = notificationInfo["eventKey"] as? String
        let event = events.first(where:{String(describing: $0.key) == eventKey})
        
        return EventViewModel.fromEvent(event!)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(0, viewModels.count - 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        let event = viewModels[indexPath.row + 1]
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
            let viewModel = viewModels[indexPath.row + 1]
            UserViewModel.current.deleteEvent(viewModel.event)
        default:
            return
        }
    }
}

