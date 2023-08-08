// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Ownable.sol";

contract PetPark is Ownable {

    enum AnimalType {
        Fish,   // 0
        Cat,    // 1
        Dog,    // 2
        Rabbit, // 3
        Parrot, // 4
        None    // 5
    }

    enum Gender {
        Male,   // 0
        Female    // 1
    }

    // Total count of Animals    
    uint256 totalAnimalCount;

    // animalType to animalCount
    mapping(uint8 => uint256) public animalCount;

    mapping(address => bool) public borrowedBefore;

    mapping(address => uint8) public borrowedType;

    event Added(AnimalType typeOfAnimal, uint256 countOfAnimals);
    event Borrowed(AnimalType typeOfAnimal);
    event Returned(uint8 typeOfAnimal);

    constructor(){
    }

    // Gives shelter to animals
    function add(AnimalType _animalType, uint256 _count) public onlyOwner{
        uint8 id = getType(_animalType);
        require(id < 5, "Invalid animal");

        animalCount[id] += _count;
        totalAnimalCount += _count;

        // emits animal type and total count of that animal type
        emit Added(_animalType, animalCount[id]); 
    }

    function getType(AnimalType _aType) public pure returns (uint8) {
        return uint8(_aType);
    }

    function borrow(uint8 _age, Gender gender, AnimalType _animalType) public {
        require( !borrowedBefore[msg.sender], "Already adopted a pet"); 
        require(_age > 0, "Invalid Age");
        uint8 id = getType(_animalType);
        require(id < 5, "Invalid animal type");
        require(animalCount[id] != 0, "Selected animal not available");

        if(gender == Gender.Male){
            require(id == 0 || id == 2, "Invalid animal for men");
        }
        else{
            if(_age < 40) {
                require(id != 1, "Invalid animal for women under 40");
            }
        }

        animalCount[id] -= 1;
        totalAnimalCount -= 1;

        borrowedBefore[msg.sender] = true;
        borrowedType[msg.sender] = id;

        emit Borrowed(_animalType);

    }

    function giveBackAnimal() public {
        require(borrowedBefore[msg.sender], "No borrowed pets"); 
        uint8 id = borrowedType[msg.sender];

        borrowedBefore[msg.sender] = false;
        animalCount[id] += 1;
        totalAnimalCount += 1;

        delete borrowedType[msg.sender];
        emit Returned(id);
    }

    function animalCounts(AnimalType animalType) public view returns (uint256){
        return animalCount[uint8(animalType)];
    }

}
