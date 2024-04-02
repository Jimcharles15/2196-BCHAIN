// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyFinalsActivity2 {
    address payable public owner;
    uint256 public creationTime;
    uint256 constant INITIAL_ETH_AMOUNT = 2 ether;
    uint256 public remainingEth;

    event EtherReceived(address indexed from, uint256 amount);
    event EtherSent(address indexed to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
        creationTime = block.timestamp;
        remainingEth = INITIAL_ETH_AMOUNT;
    }

    receive() external payable {
        remainingEth += msg.value;
        emit EtherReceived(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function sendEther(address payable _recipient, uint256 _amount) external onlyOwner {
        require(_amount <= remainingEth, "Insufficient balance");
        remainingEth -= _amount;
        _recipient.transfer(_amount);
        emit EtherSent(_recipient, _amount);
    }

    function destroy() external onlyOwner {
        
        owner.transfer(address(this).balance);
    }
}
