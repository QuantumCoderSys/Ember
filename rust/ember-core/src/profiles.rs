use serde::{Deserialize, Serialize};
use std::{collections::HashSet, error::Error, fmt};

/// A Steam application identifier; zero is never a valid game profile.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(try_from = "u32", into = "u32")]
pub struct SteamAppId(u32);

impl TryFrom<u32> for SteamAppId {
    type Error = &'static str;

    fn try_from(value: u32) -> Result<Self, Self::Error> {
        if value == 0 {
            Err("Steam App IDs must be greater than zero")
        } else {
            Ok(Self(value))
        }
    }
}

impl From<SteamAppId> for u32 {
    fn from(value: SteamAppId) -> Self {
        value.0
    }
}

/// Catalog entries describe targets for testing, not compatibility guarantees.
#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase", deny_unknown_fields)]
pub struct GameProfile {
    pub app_id: SteamAppId,
    pub name: String,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(rename_all = "camelCase", deny_unknown_fields)]
pub struct Catalog {
    pub schema_version: u32,
    pub profiles: Vec<GameProfile>,
}

#[derive(Debug)]
pub struct CatalogError(String);

impl fmt::Display for CatalogError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(&self.0)
    }
}

impl Error for CatalogError {}

impl Catalog {
    pub fn from_json(json: &str) -> Result<Self, CatalogError> {
        let catalog: Self =
            serde_json::from_str(json).map_err(|error| CatalogError(error.to_string()))?;
        if catalog.schema_version != 1 {
            return Err(CatalogError("Unsupported profile schema version".into()));
        }
        let mut seen = HashSet::new();
        for profile in &catalog.profiles {
            if profile.name.trim().is_empty() {
                return Err(CatalogError("Game names must not be empty".into()));
            }
            if !seen.insert(profile.app_id) {
                return Err(CatalogError("Duplicate Steam App ID in catalog".into()));
            }
        }
        Ok(catalog)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn valid_catalog_preserves_game_identity() {
        let catalog = Catalog::from_json(
            r#"{"schemaVersion":1,"profiles":[{"appId":42,"name":"Test game"}]}"#,
        )
        .unwrap();
        assert_eq!(u32::from(catalog.profiles[0].app_id), 42);
        assert_eq!(catalog.profiles[0].name, "Test game");
    }

    #[test]
    fn rejects_invalid_or_ambiguous_profiles() {
        for json in [
            r#"{"schemaVersion":2,"profiles":[]}"#,
            r#"{"schemaVersion":1,"profiles":[{"appId":0,"name":"Invalid"}]}"#,
            r#"{"schemaVersion":1,"profiles":[{"appId":42,"name":"  "}]}"#,
            r#"{"schemaVersion":1,"profiles":[{"appId":42,"name":"One"},{"appId":42,"name":"Two"}]}"#,
            r#"{"schemaVersion":1,"profiles":[],"unknownSetting":true}"#,
        ] {
            assert!(
                Catalog::from_json(json).is_err(),
                "Accepted invalid catalog: {json}"
            );
        }
    }
}
