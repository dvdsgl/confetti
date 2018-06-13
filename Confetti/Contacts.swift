import Foundation

import Contacts

import ConfettiKit

extension CNContact: Contact {
    public var firstName: String {
        return givenName
    }
    
    public var lastName: String? {
        return familyName
    }
    
    public var fullName: String {
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
    
    public var emails: [String] {
        return emailAddresses.map { $0.value as String }
    }
    
    public var phones: [Phone] {
        return phoneNumbers.map {
            Phone(label: $0.label, value: $0.value.stringValue)
        }
    }
}

protocol ContactStore {
    func search(query: String) -> [Contact]
}

struct NativeContactStore: ContactStore {
    let keys = [
        CNContactNamePrefixKey,
        CNContactNameSuffixKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactOrganizationNameKey,
        CNContactBirthdayKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey,
        CNContactImageDataAvailableKey,
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey
    ] as [CNKeyDescriptor] + [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
    ]
    
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
            ("David Appleseed", 0),
            ("Stu Appleseed", 1),
            ("Ellen Appleseed", 2),
            ("Carrie Appleseed", 8),
            ("Hannah Appleseed", 21),
            ("Vinicius Appleseed", 40),
            ("Steve Appleseed", 100)
        ]
        
        let now = Date().addingTimeInterval(60 * 30)
        
        return names.map { (name, daysAway) in
            let nick = name.components(separatedBy: " ").first!
            let names = name.components(separatedBy: " ")
            var contact = ManualContact(
                firstName: names[0],
                lastName: names[1],
                nick: nick,
                imageSource: .url("https://confettiapp.com/v1/test/faces/\(nick.lowercased()).jpg")
            )
            
            let target = Calendar.current.date(byAdding: DateComponents(day: daysAway), to:  now)!
            contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: target)
            
            return contact
        }
    }()
    
    func search(query: String) -> [Contact] {
        var filtered = contacts
        
        if !query.isEmpty {
            filtered = filtered.filter { contact in
                return contact.fullName.lowercased().contains(query.lowercased())
            }
        }
        
        return filtered
    }
}
