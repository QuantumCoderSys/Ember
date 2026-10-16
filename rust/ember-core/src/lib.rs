//! Ember's platform-independent state and game-profile model.
//! No runtime downloads, Steam installation, or game launches occur here yet.

pub mod profiles;

use serde::{Deserialize, Serialize};

pub const BRIDGE_API_VERSION: u32 = 1;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub enum RuntimeStatus {
    NotInstalled,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CoreSnapshot {
    pub bridge_api_version: u32,
    pub version: String,
    pub operating_system: String,
    pub architecture: String,
    pub runtime_status: RuntimeStatus,
    pub profile_count: usize,
}

pub fn snapshot() -> Result<CoreSnapshot, profiles::CatalogError> {
    let catalog = profiles::Catalog::from_json(include_str!("../../../profiles/catalog.json"))?;
    Ok(CoreSnapshot {
        bridge_api_version: BRIDGE_API_VERSION,
        version: env!("CARGO_PKG_VERSION").into(),
        operating_system: std::env::consts::OS.into(),
        architecture: std::env::consts::ARCH.into(),
        runtime_status: RuntimeStatus::NotInstalled,
        profile_count: catalog.profiles.len(),
    })
}
