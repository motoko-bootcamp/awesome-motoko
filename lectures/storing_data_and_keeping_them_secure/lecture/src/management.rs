use ic_kit::{Principal, ic, macros::init};

pub struct Admins(pub Vec<Principal>);

impl Default for Admins {
    fn default() -> Self {
        panic!()
    }
}

pub fn is_admin(id: Principal) -> bool {
    let admins = &ic::get::<Admins>().0;
    admins.contains(&id)
}

#[init]
fn init() {
    ic::store(Admins(vec![ic::caller()]));
}