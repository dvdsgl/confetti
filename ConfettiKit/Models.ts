class FirebaseModel {
    key?: string;
}

/** #TopLevel */
export class Event extends FirebaseModel {
    occasion: Occasion;
    person: Person;
}

export class Person {
firstName: string;
    lastName?: string;
    nickname?: string;
    
    photoUUID?: string;
    
    emails?: string[];
    phones?: { label?: string, value: string }[];
}

export class Occasion {
    kind: OccasionKind;
    
    /** @TJS-type integer */
    year?: number;
    /** @TJS-type integer */
    month: number;
    /** @TJS-type integer */
    day: number;
}

export type OccasionKind =
    "Birthday" |
    "Anniversary" |
    "Mother's Day" |
    "Father's Day";
