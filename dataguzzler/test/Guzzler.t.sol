// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {Guzzler} from "../src/Guzzler.sol";

contract GuzzlerTest is Test {
    Guzzler public guzzler;

    function setUp() public {
        guzzler = new Guzzler();
    }

    function test_case1() public {
        bytes memory instructions = hex"0000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000001000";
        (uint256 calldataloadx, uint256 first_byte) = guzzler.main(instructions);
        guzzler.main(instructions);
        console.log("calldataloadx: ", calldataloadx);
        console.log("first_byte: ", first_byte);
        assertEq(uint256(vm.load(address(guzzler), bytes32(uint256(1)))), 4096);
    }
}
