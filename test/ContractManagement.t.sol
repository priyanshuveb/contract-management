// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ContractManagement} from "../src/ContractManagement.sol";

contract ContractManagementTest is Test {
    ContractManagement public contractManagement;
    address public ALICE = makeAddr("alice");
    address public RILEY = makeAddr("riley");
    address public DEREK = makeAddr("derek");
    address[] users = [RILEY, DEREK];

    function setUp() public {
        console2.log(ALICE);
        contractManagement = new ContractManagement(ALICE);
        //counter.setNumber(0);
    }

    function test_GetAdmin() external view {
        address admin = contractManagement.admin();
        console2.log(admin);
        assertEq(admin, ALICE);
    }

    function test_SetNewAdmin() external {
        vm.prank(ALICE);
        contractManagement.setAdmin(RILEY);
        assertEq(RILEY, contractManagement.admin());
    }

    function testFail_UnauthorizedSetAdmin() public {
        vm.prank(RILEY);
        vm.expectRevert(bytes(""));
        contractManagement.setAdmin(DEREK);
    }

    function test_AuthorizeUsers() external {
        vm.prank(ALICE);
        contractManagement.authorizeUsers(users);
        assertEq(contractManagement.authorizedUsers(RILEY), true);
        assertEq(contractManagement.authorizedUsers(DEREK), true);
    }

    function test_UnauthorizeUsers() external {
        vm.startPrank(ALICE);
        contractManagement.authorizeUsers(users);
        assertEq(contractManagement.authorizedUsers(RILEY), true);
        contractManagement.unauthorizeUsers(users);
        assertEq(contractManagement.authorizedUsers(RILEY), false);
        vm.stopPrank();       
    }

    function test_AddContractByAuthorizedUsers() external {
        address contract1 = makeAddr("contract1");
        string memory desc = "contract 1";
        vm.prank(ALICE);
        contractManagement.authorizeUsers(users);
        vm.prank(RILEY);
        contractManagement.addContract(contract1, desc);
        assertEq(bytes(desc), bytes(contractManagement.contractDesc(contract1)));
    }

    function testFail_UnauthorizedUserAccessToAddContract() external {
        address contract1 = makeAddr("contract1");
        string memory desc = "contract 1";
        address NANCY = makeAddr("NANCY");
        vm.prank(ALICE);
        contractManagement.authorizeUsers(users);
        vm.prank(NANCY);
        vm.expectRevert(bytes(""));
        contractManagement.addContract(contract1, desc);
    }

    function test_UpdateContractIfOnlyExists() external {
        address contract1 = makeAddr("contract1");
        address contract2 = makeAddr("contract2");
        string memory desc = "contract 1";
        string memory desc2 = "contract 1 update";
        vm.prank(ALICE);
        contractManagement.authorizeUsers(users);

        vm.startPrank(RILEY);
        contractManagement.addContract(contract1, desc);
        contractManagement.updateContract(contract1, desc2);
        assertEq(bytes(desc2), bytes(contractManagement.contractDesc(contract1)));

        vm.expectRevert();
        contractManagement.updateContract(contract2, desc2);
        vm.stopPrank();
    }

    function test_RemoveContract() external {
        address contract1 = makeAddr("contract1");
        string memory desc = "contract 1";
        vm.prank(ALICE);
        contractManagement.authorizeUsers(users);

        vm.startPrank(RILEY);
        contractManagement.addContract(contract1, desc);
        contractManagement.removeContract(contract1);
        assertEq(bytes(""), bytes(contractManagement.contractDesc(contract1)));

        vm.stopPrank();
    }
}
