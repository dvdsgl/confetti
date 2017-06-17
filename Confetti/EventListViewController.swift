import UIKit
import ConfettiKit

import Firebase

class EventListViewController: UITableViewController {
    
    @IBOutlet var heroViewContainer: UIView!
    @IBOutlet var heroView: HeroView!
    
    var detailViewController: DetailViewController? = nil
    var viewModels = [EventViewModel]()
    var registrations = [NotificationRegistration]()
    
    // Set up height for stretchy header
    private let tableHeaderHeight: CGFloat = 300
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.isNavigationBarHidden = true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up stretchy header
        heroViewContainer = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(heroViewContainer)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        updateHeaderView()
        
        let onEventsChanged = UserViewModel.current.onEventsChanged {
            self.updateWith(events: $0)
        }
        registrations.append(onEventsChanged)
    }
    
    func updateHeaderView () {
     var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        heroViewContainer.frame = headerRect
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
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

