// Advertising that only bonded phones can connect to. The Bluefruit library
// always advertises with filter policy "any", so after the pairing window the
// sketch stops the library's advertising and calls this instead.
#pragma once

#include <bluefruit.h>

enum OrrWhitelistResult : uint8_t {
  ORR_WHITELIST_STARTED,   // advertising; connections from bonded phones only
  ORR_WHITELIST_NO_BONDS,  // no bond in the flash: nothing started
  ORR_WHITELIST_FAILED     // a SoftDevice call failed: nothing started
};

// Loads the peripheral bonds from the flash (up to 8), sets them as the
// SoftDevice's device identities and whitelist, and starts connectable
// advertising with the library's advertising and scan response data. Call
// with no connection and the library's advertising stopped. `interval` is in
// 0.625 ms units; the advertising has no timeout.
OrrWhitelistResult orrStartWhitelistAdvertising(uint16_t interval);

// After ORR_WHITELIST_FAILED: the SoftDevice call and its error code.
const char *orrWhitelistFailure();
