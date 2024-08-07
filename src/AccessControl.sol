// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract AccessControl {
    address public admin;

    mapping(address => bool) public authorizedUsers;

    event AdminUpdated(address indexed newAdmin, address oldAdmin);
    event UsersAuthorized(address[] users);
    event UsersUnauthorized(address[] users);

    modifier onlyAdmin() {
        require(msg.sender == admin, "AccessControl: Only admin access");
        _;
    }

    modifier onlyAuthorizedUser() {
        require(authorizedUsers[msg.sender], "AccessControl: Only authorized user access");
        _;
    }

    function setAdmin(address _newAdmin) public onlyAdmin {
        emit AdminUpdated(_newAdmin, admin);
        admin = _newAdmin;
    }

    function authorizeUsers(address[] memory _authorizedusers) public onlyAdmin {
        for (uint256 i = 0; i < _authorizedusers.length;) {
            authorizedUsers[_authorizedusers[i]] = true;
            ++i;
        }
        emit UsersAuthorized(_authorizedusers);
    }

    function unauthorizeUsers(address[] memory _authorizedusers) public onlyAdmin {
        for (uint256 i = 0; i < _authorizedusers.length;) {
            delete authorizedUsers[_authorizedusers[i]];
            ++i;
        }
        emit UsersUnauthorized(_authorizedusers);
    }
}
