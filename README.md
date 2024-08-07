### Setup

```shell
$ git clone https://github.com/priyanshuveb/contract-management.git
$ cd contract-management
```
### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```
 ### Coverage
To see the test coverage
```shell
$ forge coverage
```

### Test Cases
- `test_GetAdmin`
  - Tests if the admin has been set correctly 
- `test_SetNewAdmin`
  - Sets the new admin, can only be set by old admin
- `testFail_UnauthorizedSetAdmin`
  - Tests if unauthorized account tried to update admin address
- `test_AuthorizeUsers`
  - Tests if the authorized users has been set correctly
- `test_AddContractByAuthorizedUsers`
  - Tests the contract information can only be added by the authorized users otherwise reverts
- `testFail_UnauthorizedUserAccessToAddContract` 
  - Tests the revert on unauthorised access to add a new contract
- `test_UpdateContractIfOnlyExists`
  - Tests the contract can only be updated if it already exists otherwise reverts
- `test_RemoveContract`
  - Tests if only authorised users can remove the contracts


### Contract Functions
- `setAdmin(new_admin)`
  - Admin access only, takes 1 param, sets the new_admin as the admin of the contract, an admin can authorize/unauthorize users to access contract functions
- `authorizeUsers(address[]_users)`
  - Admin access only, takes 1 param, authorizes the list of users
- `unauthorizeUsers(address[]_users)`
  - Admin access only, takes 1 param, unauthorizes the list of users
- `addContract(contract_address,dscription)`
  - Authorized access only, takes 2 params, sets the mapping of a contract address to its description
- `updateContract(contract_address,dscription)`
  - Authorized access only, takes 2 params, updates the mapping of a contract address to its new description only if it already exists otherwise reverts
- `removeContract(address_contract)`
  - Authorized access only, takes 1 param, deletes the description assosciated with the fetched contract address


### Design Desicions

1. AccessControl.sol: According to the requirement, kept the access control clean and simple instead of relying on openzeppelin's version
2. Mappings: Tried to not use arrays at all, mappings are much more efficient and cost effective
3. for loop: Tried to implement the pre increment for loop, which saves on gas costs in comparison to the post increment
4. Modularity: Although the access control is designed simply, still its code kept in different file and inherited in the main contract to enable code modularity which is an efficient approach
5. Events: All major state changes are accompanied by the respective events for the better off blockchain communication