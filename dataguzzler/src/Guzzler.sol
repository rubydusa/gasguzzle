// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

// TODO: support also CALLCODE, DELEGATECALL, STATICCALL, TSTORE
contract Guzzler {
    function main(bytes calldata data) external {
        // simple non compact scheme

        // if byte is 0, then storage write
        //     next 32 bytes are slot
        //     next 32 bytes are value
        // if byte is 1, then external call
        //     next 32 bytes are value (wei)
        //     next 32 bytes are gas
        //     next 32 bytes are address
        //     next 32 bytes are calldata length (X)
        //     next X bytes are calldata
        assembly {
            let x := data.offset
            let end := add(data.offset, data.length)
            for { } lt(x, end) { } {
                let first_byte := shl(248, calldataload(x))
                if iszero(first_byte) {
                    x := add(x, 0x01)
                    let slot := calldataload(x)
                    x := add(x, 0x20)
                    let value := calldataload(x)
                    sstore(slot, value)
                }
                if eq(first_byte, 1) {
                    x := add(x, 0x01)
                    let callgas := calldataload(x)
                    x := add(x, 0x20)
                    let target := calldataload(x)
                    x := add(x, 0x20)
                    let value := calldataload(x)
                    x := add(x, 0x20)
                    let length := calldataload(x)
                    x := add(x, 0x20)
                    let success := call(callgas, target, value, x, length, 0, 0)
                    if iszero(success) {
                        // revert with the offset in the call data
                        mstore(0, sub(x, data.offset))
                        revert(0, 0x20)
                    }
                }
            }
        }
    }
}
