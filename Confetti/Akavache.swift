import SQLite
import BSON

import Foundation

import ConfettiKit

class Akavache {
    fileprivate static var userBlobCache: URL? {
        guard let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        return appSupport
            .appendingPathComponent("Confetti")
            .appendingPathComponent("BlobCache")
            .appendingPathComponent("userblobs.db")
    }
    
    fileprivate static var cacheElementRows: AnySequence<Row>? {
        guard let blobcache = userBlobCache else { return nil }
        guard let db = try? Connection(blobcache.absoluteString) else { return nil }
        return try? db.prepare(Table("CacheElement"))
    }
    
    static func findRow(_ predicate: (Row) -> Bool) -> Row? {
        guard let cacheElements = cacheElementRows else { return nil }
        for element in cacheElements  {
            if predicate(element) {
                return element
            }
        }
        return nil
    }
    
    static func getEvents() -> [AkavacheOrAzureEvent] {
        var events = [AkavacheOrAzureEvent]()
        
        guard let cacheElements = cacheElementRows else { return [] }
        
        for row in cacheElements {
            guard let type = row[Expression<String?>("TypeName")] else { continue }
            if type != "Confetti.EventModel" { continue }
           
            let blob = row[Expression<Blob>("Value")]
            let doc = Document(data: blob.bytes)

            let occasion = String(doc["Value", "Occasion"])!
            let date = Date(doc["Value", "Date"])!
            let specifiesYear = Bool(doc["Value", "SpecifiesYear"])!

            let person = try! AkavacheOrAzurePerson(String(doc["Value", "Person"])!)

            events.append(AkavacheOrAzureEvent(
                person: person,
                date: date,
                occasionKind: occasion,
                hasYear: specifiesYear
            ))
        }
        return events
    }
    
    static func getBlobData(guid: String) -> Data? {
        guard let row = findRow({ guid == $0[Expression<String>("Key")] }) else { return nil }
        let blob = row[Expression<Blob>("Value")]
        return Data(bytes: blob.bytes)
    }
}
