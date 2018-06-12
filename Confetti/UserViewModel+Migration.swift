import Foundation

import ConfettiKit

extension UserViewModel {
    func performMigrations() {
        var generation = UserDefaults.standard.integer(forKey: "migration")
        switch generation {
        case 0:
            // If we migrate any Azure data, we don't try to migrate Akavache
            if !migrateFromAzureEasyTables() {
                let _ = migrateFromAkavache()
            }
            generation = 1
        default:
            break
        }
        UserDefaults.standard.set(generation, forKey: "migration")
    }
    
    private func tryMigrateAkavacheImage(guid: String, toEvent: Event) {
        let viewModel = EventViewModel.fromEvent(toEvent)
        if let data = Akavache.getBlobData(guid: guid) {
            viewModel.saveImage(data: data)
        }
    }
    
    private func migrateFromAkavache() -> Bool {
        let events = Akavache.getEvents()
        for oldEvent in events {
            let event = addEvent(oldEvent.toEvent())
            if let guid = oldEvent.person.photoKey {
                tryMigrateAkavacheImage(guid: guid, toEvent: event)
            }
        }
        return !events.isEmpty
    }
    
    private func migrateFromAzureEasyTables() -> Bool {
        let azureEvents = (try? Azure.getEasyTableEvents()) ?? []
        for azureEvent in azureEvents {
            let event = addEvent(azureEvent.toEvent())
            if let guid = azureEvent.person.photoKey {
                tryMigrateAkavacheImage(guid: guid, toEvent: event)
            }
        }
        return !azureEvents.isEmpty
    }
}
