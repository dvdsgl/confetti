import Foundation

import Contacts

import ConfettiKit

extension CNContact: Contact {
    public var name: String {
        return CNContactFormatter.string(from: self, style: .fullName)!
    }
    
    public var nick: String? {
        return nickname.isEmpty ? nil : nickname
    }
    public var imageSource: ImageSource? {
        if let data = imageData {
            return .data(data)
        }
        return nil
    }
    
}

protocol ContactStore {
    func search(query: String) -> [Contact]
}

struct NativeContactStore: ContactStore {
    let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactNameSuffixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor]
    
    func search(query: String) -> [Contact] {
        let store = CNContactStore()
        let predicate: NSPredicate
        
        var contacts = [Contact]()
        
        if query.isEmpty {
            predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
        } else {
            predicate = CNContact.predicateForContacts(matchingName: query)
        }
        do {
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
        }
        catch {
            print("Error!")
        }
        
        return contacts
    }
}

struct TestContactStore: ContactStore {
    let contacts: [ManualContact] = {
        
        let names = [
            "David Appleseed",
            "Stu Appleseed",
            "Ellen Appleseed",
            "Carrie Appleseed",
            "Hannah Appleseed",
            "Vinicius Appleseed",
            "Steve Appleseed"
        ]
        
        var today = Date().addingTimeInterval(60 * 30)
        
        return names.map { name in
            let nick = name.components(separatedBy: " ").first!
            var contact = ManualContact(
                name,
                nick: nick,
                imageSource: .url("https://confettiapp.com/v1/test/faces/\(nick.lowercased()).jpg")
            )
            contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: today)
            today = Calendar.current.date(byAdding: DateComponents(day: 1), to: today)!
            return contact
        }
    }()
    
    func search(query: String) -> [Contact] {
        var filtered = contacts
        
        if !query.isEmpty {
            filtered = filtered.filter { contact in
                return contact.name.lowercased().contains(query.lowercased())
            }
        }
        
        return filtered
    }
}
