syntax = "proto3";
package cosmos.dydxprotocol.indexer.payload;

import "google/protobuf/timestamp.proto";

option go_package = "github.com/cosmos/cosmos-sdk/x/types";

// IndexerTendermintEvent contains the base64 encoded event proto emitted from the V4 application
// as well as additional metadata to determine the ordering of the event within the block and the
// subtype of the event.
message IndexerTendermintEvent {
string subtype = 1;
// Base64 encoded proto from the Tendermint event.
string data = 2;
}

message TransactionEvents {
repeated IndexerTendermintEvent events = 1;
}

// IndexerTendermintBlock contains all the events for the block along with metadata for the block
// height, timestamp of the block and a list of all the hashes of the transactions within the
// block. The transaction hashes follow the ordering of the transactions as they appear within
// the block. The transaction events contain the events and follow the ordering of the transactions
// that they appear within.
message IndexerTendermintBlock {
uint32                     height    = 1;
google.protobuf.Timestamp  time      = 2;
repeated TransactionEvents tx_events = 3;
repeated string            tx_hashes = 4;
}
