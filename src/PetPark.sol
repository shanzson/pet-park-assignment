// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PetPark is Ownable {

    enum AnimalType {
        Fish,   // 0
        Cat,    // 1
        Dog,    // 2
        Rabbit, // 3
        Parrot  // 4
    }

    // Total count of Animals    
    uint256 totalAnimalCount;

    // animalType to animalCount
    mapping(uint8 => uint256) public animalCount;

    mapping(address => bool) public borrowedBefore;

    event Add(AnimalType typeOfAnimal, uint256 countOfAnimals);
    event Borrowed(AnimalType typeOfAnimal, address Borrower);

    constructor(){
    }

    // Gives shelter to animals
    function add(AnimalType _animalType, uint256 _count) public onlyOwner{
        uint8 id = getType(_animalType);

        animalCount[id] += _count;
        totalAnimalCount += _count;

        // emits animal type and total count of that animal type
        emit Add(_animalType, animalCount[id]); 
    }

    function getType(AnimalType _aType) public pure returns (uint8) {
        return uint8(_aType);
    }

    function borrow(uint8 _age, bool gender, AnimalType _animalType) public {
        require( !borrowedBefore[msg.sender] , "Should not have borrowed before"); 
        uint8 id = getType(_animalType);
        
        // gender as true represents male
        if(gender){
            require(id == 0 || id == 2, "Men can borrow only Fish and Dog");
        }
        else{
            if(_age < 40) {
                require(id != 1, "Women under 40 are not allowed to borrow Cat");
            }
        }

        animalCount[id] -= 1;
        totalAnimalCount -= 1;

        borrowedBefore[msg.sender] = true;

        emit Borrowed(_animalType, msg.sender);

    }

}