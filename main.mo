import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

actor Trips {

  /**
   * Types
   */

  // Seyahat planı kimliği türü
  public type TripId = Nat32;

  // Seyahat planı türü
  public type Trip = {
    destination: Text;
    date: Text;
    participants: List.List<Text>;
  };

  /**
   * Application State
   */

  // Bir sonraki seyahat kimliği
  private stable var next: TripId = 0;

  // Seyahat planlarını tutacak Trie
  private stable var trips: Trie.Trie<TripId, Trip> = Trie.empty();

  /**
   * High-Level API
   */

  // Seyahat planı oluşturma
  public func create(trip: Trip) : async TripId {
    let tripId = next;
    next += 1;
    trips := Trie.replace(
      trips,
      key(tripId),
      Nat32.equal,
      ?trip,
    ).0;
    return tripId;
  };

  // Seyahat planı okuma
  public query func read(tripId: TripId) : async ?Trip {
    let result = Trie.find(trips, key(tripId), Nat32.equal);
    return result;
  };

  // Seyahat planını güncelleme
  public func update(tripId: TripId, trip: Trip) : async Bool {
    let result = Trie.find(trips, key(tripId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      trips := Trie.replace(
        trips,
        key(tripId),
        Nat32.equal,
        ?trip,
      ).0;
    };
    return exists;
  };

  // Seyahat planını silme
  public func delete(tripId: TripId) : async Bool {
    let result = Trie.find(trips, key(tripId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      trips := Trie.replace(
        trips,
        key(tripId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  /**
   * Utilities
   */

  // TripId için bir Trie anahtarı oluşturma
  private func key(x: TripId) : Trie.Key<TripId> {
    return { hash = x; key = x };
  };
};
