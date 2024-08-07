// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "./AccessControl.sol";

contract ContractManagement is AccessControl {
    mapping(address => string) public contractDesc;

    event ContractAdded(address indexed theContract, string description);
    event ContractUpdated(address indexed theContract, string description);
    event ContractRemoved(address indexed theContract);

    constructor(address _admin) {
        admin = _admin;
        emit AdminUpdated(admin, address(0));
    }

    function addContract(address _contract, string memory _description) public onlyAuthorizedUser {
        contractDesc[_contract] = _description;
        emit ContractAdded(_contract, _description);
    }

    function updateContract(address _contract, string memory _description) public onlyAuthorizedUser {
        require(bytes(contractDesc[_contract]).length != 0, "Contract does not exists");
        contractDesc[_contract] = _description;
        emit ContractUpdated(_contract, _description);
    }

    function removeContract(address _contract) public onlyAuthorizedUser {
        delete contractDesc[_contract];
        emit ContractRemoved(_contract);
    }
}
