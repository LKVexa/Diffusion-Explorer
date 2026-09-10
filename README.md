## Repository cleanup and packaging updates

This update was a safe, compatibility-focused cleanup via the Junkyard Chop Shop workflow to improve project setup and tooling reliability without changing core model/simulation code.

### What changed

- Repaired workspace/package setup for local installation and execution.
- Updated project scripts and metadata so each app resolves local shared packages correctly.
- Added tooling and setup helper scripts for repeatable local workflows.
- Added documentation for setup expectations and known environment constraints.
- Preserved all original app source and algorithm files; changes are intentionally scoped to build/test/developer experience only.

### Files added/updated

#### Updated
- `README.md` (root): clarified setup and execution flow.
- `diffusion-explorer/package.json`: updated workspace and script wiring.
- App `package.json` files: fixed local workspace package references to the correct library aliases.

#### Added
- `CHOP-SHOP-RECEIPT.md`: changelog + provenance notes for this update pass.
- `SETUP.md`: environment and setup guidance.
- `diffusion-explorer/scripts/doctor.mjs`: dependency and workspace diagnostics.
- `diffusion-explorer/scripts/copy-wasm.mjs`: robust TFJS-WASM asset copy helper.
- `diffusion-explorer/scripts/tests/tooling.test.mjs`: in-process tooling verification tests.

### Validation summary

- Packaging integrity checks (file inventory, locks, CRC, byte-level checks) passed.
- Tooling tests passed.
- A full app build remains blocked by environment/dependency availability (private `@helblazer811/tempus` package).

### Notes

- No donor code was imported.
- No core algorithm/model implementation files were modified.
- The intent was to make install/setup reliable while keeping behavior and app code unchanged.
