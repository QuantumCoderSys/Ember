//! A versioned JSON snapshot over a deliberately small C ABI.

use std::{ffi::CString, os::raw::c_char, panic::catch_unwind, ptr};

/// Returns owned UTF-8 JSON, or null on failure. Release with ember_core_string_free.
#[unsafe(no_mangle)]
pub extern "C" fn ember_core_snapshot_json() -> *mut c_char {
    catch_unwind(|| {
        let snapshot = ember_core::snapshot().ok()?;
        let json = serde_json::to_string(&snapshot).ok()?;
        CString::new(json).ok().map(CString::into_raw)
    })
    .ok()
    .flatten()
    .unwrap_or(ptr::null_mut())
}

/// Releases a string returned by ember_core_snapshot_json. Null is a no-op.
///
/// # Safety
/// A non-null pointer must have been returned by ember_core_snapshot_json and
/// must not have been freed before. Do not pass Swift-allocated strings here.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ember_core_string_free(value: *mut c_char) {
    if !value.is_null() {
        // SAFETY: The caller transfers exactly one allocation owned by this ABI.
        drop(unsafe { CString::from_raw(value) });
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::ffi::CStr;

    #[test]
    fn bridge_returns_owned_decodable_snapshots() {
        for _ in 0..32 {
            let pointer = ember_core_snapshot_json();
            assert!(!pointer.is_null());
            // SAFETY: A fresh ABI allocation remains live until the free below.
            let bytes = unsafe { CStr::from_ptr(pointer) }.to_bytes();
            let snapshot: ember_core::CoreSnapshot = serde_json::from_slice(bytes).unwrap();
            assert_eq!(snapshot.bridge_api_version, ember_core::BRIDGE_API_VERSION);
            assert_eq!(
                snapshot.runtime_status,
                ember_core::RuntimeStatus::NotInstalled
            );
            // SAFETY: This pointer is freed exactly once, using the matching allocator.
            unsafe { ember_core_string_free(pointer) };
        }
    }

    #[test]
    fn freeing_null_is_safe() {
        // SAFETY: Null is explicitly accepted by the ABI.
        unsafe { ember_core_string_free(ptr::null_mut()) };
    }
}
