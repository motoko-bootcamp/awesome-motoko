use ic_kit::{candid::CandidType, Principal};
use serde::Deserialize;

#[derive(CandidType, Deserialize)]
pub struct Metadata {
    pub name: String,
    pub description: String,
    pub id: Principal,
}

#[derive(CandidType, Deserialize)]
pub enum Error {
    NotAuthorized,
    NonExistentItem,
    BadParameters,
    Unknown(String)
}