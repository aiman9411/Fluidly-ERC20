//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**
@title Fluidly token (FLY)
@notice This is a smart contract - a program that can deployed into Ethereum blockchain
@author Aiman Nazmi
*/


interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Fluidly is IERC20 {
    // @notice State variable to store total supply
    uint totalTokenSupply;

    // @notice Mapping to check user's balance
    mapping(address => uint) balance;

    // @notice Mapping to check total allowance
    mapping(address => mapping(address => uint)) totalAllowance;

    // @notice State variable to store name and symbol of token
    string public name = "Fluidly";
    string public symbol = "FLY";

    // @notice State variable to store decimal of token
    uint8 public decimal = 18;

    // @notice Users can interact with this function to view current totak supply of token
    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    // @notice Users can interact with this token to view their balance
    // @param account Address that users want to check balance
    function balanceOf(address account) external view returns (uint256) {
        return balance[account];
    }

    // @notice User can interact with this token to transfer his/her token
    // @param to Recipient's address
    // @param amount Total token users want to send
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balance[msg.sender] >= amount, "Amount is insufficient");
        balance[msg.sender] -= amount;
        balance[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // @notice Users can use this function to view total allowance granted
    // @param owner Owner of token
    // @param spender Users who are allowed to spend the token
    function allowance(address owner, address spender) external view returns (uint256) {
        return totalAllowance[owner][spender];
    }

    // @notice Users can interact with this function to approve spender
    // @param spender Spender's address
    // @param amount Amount of token to qualify as allowance
    function approve(address spender, uint256 amount) external returns (bool) {
        require(balance[msg.sender] >= amount);
        balance[msg.sender] -= amount;
        totalAllowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // @notice Spenders can interact with this fucntion to transfer token on owner's behalf
    // @param from Owner's address
    // @param to Recipient's address
    // @param amount Amount of token to transfer
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(totalAllowance[from][msg.sender] >= amount, "Insufficient Amount");
        totalAllowance[from][msg.sender] -= amount;
        balance[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    // @notice Users can interact with this function to mint token
    // @param amount Amount of token to mint
    function mint(uint amount) external {
        totalTokenSupply += amount;
        balance[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // @notice Users can interact with this function to burn token
    // @param amount Amount of token to get burned
    function burn(uint amount) external {
        totalTokenSupply -= amount;
        balance[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}
