use crate::common_types::*;
use crate::management::*;

use ic_kit::*;
use ic_kit::macros::*;
use std::collections::BTreeMap;


#[derive(Default)]
pub struct BTreeMapDB(BTreeMap<Principal, Metadata>);

impl BTreeMapDB {
    pub fn archive(&mut self) -> Vec<(Principal, Metadata)> {
        let map = std::mem::replace(&mut self.0, BTreeMap::new());
        map.into_iter().collect()
    }

    pub fn load(&mut self, archive: Vec<(Principal, Metadata)>) {
        self.0 = archive.into_iter().collect();
    }

    pub fn add(&mut self, metadata: Metadata) -> Result<(), Error> {
        let id: Principal = metadata.id;
        self.0.insert(metadata.id, metadata);
        Ok(())
    }

    pub fn remove(&mut self, id: Principal) -> Result<(), Error> {
        if !self.0.contains_key(&id) {
            return Err(Error::NonExistentItem);
        }
        self.0.remove(&id);
        Ok(())
    }

    pub fn get(&mut self, id: Principal) -> Option<&Metadata> {
        self.0.get(&id)
    }

    pub fn get_all(&self) -> Vec<&Metadata> {
        self.0.values().collect()
    }
}

#[update]
pub fn add_btreemap(metadata: Metadata) -> Result<(), Error> {
    if !is_admin(ic::caller()) {
        return Err(Error::NotAuthorized);
    }
    let db = ic::get_mut::<BTreeMapDB>();
    db.add(metadata)
}

#[update]
pub fn remove_btreemap(id: Principal) -> Result<(), Error> {
    if !is_admin(ic::caller()) {
        return Err(Error::NotAuthorized);
    }
    let db = ic::get_mut::<BTreeMapDB>();
    db.remove(id)
}

#[query]
pub fn get_btreemap(id: Principal) -> Option<&'static Metadata> {
    let db = ic::get_mut::<BTreeMapDB>();
    db.get(id)
}

#[query]
pub fn get_all_btreemap() -> Vec<&'static Metadata> {
    let db = ic::get::<BTreeMapDB>();
    db.get_all()
}