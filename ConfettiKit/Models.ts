class Event {
    key?: string;
    name: string;
    person: Person;
    occasion: Occasion;
}

class Person {
    name: string;
    nickname?: string;
    photoUUID?: string;
    
    emails: LabeledString[];
    phones: LabeledString[];
}

class LabeledString {
    value: string;
    label?: string;
}

class Occasion {
    kind: OccasionKind;
    month: number;
    day: number;
    year?: number;
}

enum OccasionKind {
    Birthday = "Birthday",
    Anniversary = "Anniversary",
    MothersDay = "Mother's Day",
    FathersDay = "Father's Day"
}
