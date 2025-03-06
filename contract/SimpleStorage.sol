// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimpleStorage {
    string public word;
    uint256 public favoriteNumber;

    struct People {
        string name;
        uint256 age;
    }

    People[] public people;

    //mapping
    mapping(string => uint256) public peopleName;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    //view annd pure is // Gas-free when called externally
    //if u want to return the string 
    // function retrieve() public view returns (string memory) {
    //     return string(abi.encodePacked(word, " COBA 1"));
    // }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    //calldata => temporary variable cant modified => low gas fee => function scope => useCase(external funtion parameter),
    //memory => temporary can modified => medium gas fee => function scope => useCase(function argument , local variable),
    //storage => permanent can modified => high gas fee => blockhain => useCase(Contract State)
    function addPerson(string memory _name, uint256 _age) public {
        people.push(People(_name, _age));
        peopleName[_name] = _age;
    }

    function getAllPeople() public view returns (People[] memory) {
        return people;
    }
}
