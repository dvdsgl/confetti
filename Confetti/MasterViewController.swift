import UIKit
import ConfettiKit

import AvatarImageView
import SDWebImage
import DynamicColor

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: AvatarImageView!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public static let defaultHeight: CGFloat = 80;
    
    struct AvatarConfig: AvatarImageViewConfiguration {
        var shape: Shape = .circle
    }
    
    struct AvatarData: AvatarImageViewDataSource {
        var name: String
        
        var bgColor: UIColor? {
            return Colors.accents[abs(avatarId) % Colors.accents.count]
        }
        
        init(name: String) {
            self.name = name
        }
    }
    
    override func awakeFromNib() {
        photoView.layer.cornerRadius = photoView.bounds.width / 2
    }
    
    public func setEvent(_ event: EventViewModel) {
        nameLabel.text = event.person.firstName
        descriptionLabel.text = event.description
        
        photoView.configuration = AvatarConfig()
        photoView.dataSource = AvatarData(name: event.person.firstName)
        
        if let photoUrl = event.person.photoUrl {
            photoView.sd_setImage(with: URL(string: photoUrl))
        }
        
        countdown.text = event.countdown
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = Events.samples.sorted(by: { $0.daysAway < $1.daysAway })

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let birthday = Event(person: Person.david, month: 3, day: 25, year: 1986)
        objects.insert(EventViewModel(birthday), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        
        //cell.photoView!.configuration = AvatarImageViewConfiguration()
        

        let event = objects[indexPath.row]
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
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

