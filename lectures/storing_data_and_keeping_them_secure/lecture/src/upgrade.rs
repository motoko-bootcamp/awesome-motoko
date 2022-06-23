// Project imports
use crate::common_types::Metadata;
use crate::hashmap::HashMapDB;
use crate::btreemap::BTreeMapDB;
use crate::management::Admins;

// IC imports
use ic_kit::*;
use ic_kit::ic::*;
use ic_kit::macros::*;
use ic_kit::candid::CandidType;
use serde::Deserialize;

#[derive(CandidType, Deserialize)]
struct StableStorage {
    hashmap_db: Vec<(Principal, Metadata)>,
    btreemap_db: Vec<(Principal, Metadata)>,
    admins: Vec<Principal>,
}

#[pre_upgrade]
pub fn pre_upgrade() {
    let hashmap_db = ic::get_mut::<HashMapDB>().archive();
    let btreemap_db = ic::get_mut::<BTreeMapDB>().archive();
    let admins = ic::get_mut::<Admins>().0.clone();

    let stable = StableStorage { hashmap_db, btreemap_db, admins };

    match ic::stable_store((stable,)) {
        Ok(_) => (),
        Err(candid_err) => {
            trap(&format!(
                "An error occurred when saving to stable memory (pre_upgrade): {:?}",
                candid_err
            ));
        }
    };
}

#[post_upgrade]
pub fn post_upgrade() {
    if let Ok((stable,)) = ic::stable_restore::<(StableStorage,)>() {
        ic::get_mut::<HashMapDB>().load(stable.hashmap_db);
        ic::get_mut::<BTreeMapDB>().load(stable.btreemap_db);
        ic::store(Admins(stable.admins));
    }
}
