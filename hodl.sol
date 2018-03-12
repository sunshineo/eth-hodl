pragma solidity ^0.4.0;

contract HODL {
    struct Deposit {
        uint value;
        uint matureTime;
    }
    // An address can deposit multiple times with different mature time
    mapping (address => Deposit[]) private blanceMap;
    function () payable {
        hodlSeconds(0);
    }

    function hodlDays(uint matureDays) payable {
        hodlHours(matureDays * 24);
    }

    function hodlHours(uint matureHours) payable {
        hodlMinutes(matureHours * 60);
    }

    function hodlMinutes(uint matureMinutes) payable {
        hodlSeconds(matureMinutes * 60);
    }

    function hodlSeconds(uint matureSeconds) payable {
        require(matureSeconds <= 365 * 24 * 60 * 60); // Limit max hodl time to a year to prevent accidents
        uint value = msg.value;
        require(value > 0);
        uint matureTime = block.timestamp + matureSeconds;
        Deposit memory d = Deposit(value, matureTime);
        blanceMap[msg.sender].push(d);
    }

    function getTotalBalance() constant returns (uint) {
        return getTotalBalance(msg.sender);
    }

    function getTotalBalance(address addr) constant returns (uint) {
        uint totalBalance = 0;
        Deposit[] deposits = blanceMap[addr];
        for (uint i=0; i<deposits.length; i++) {
            Deposit deposit = deposits[i];
            totalBalance += deposit.value;
        }
        return totalBalance;
    }

    // Mature means it has been long enough to withdraw
    function getMatureBalance() constant returns (uint) {
        return getMatureBalance(msg.sender);
    }

    function getMatureBalance(address addr) constant returns (uint) {
        uint totalBalance = 0;
        Deposit[] deposits = blanceMap[addr];
        for (uint i=0; i<deposits.length; i++) {
            Deposit deposit = deposits[i];
            if (block.timestamp > deposit.matureTime) {
                totalBalance += deposit.value;
            }
        }
        return totalBalance;
    }

    // Will withdraw the sum of all mature deposits
    function withdraw() returns (bool) {
        uint balanceToWithdraw = 0;
        address sender = msg.sender;
        Deposit[] deposits = blanceMap[sender];
        uint length = deposits.length;
        for (uint i=0; i<length; i++) {
            Deposit deposit = deposits[i];
            if (block.timestamp > deposit.matureTime) {
                balanceToWithdraw += deposit.value;

                // Move the last deposit in the array to current index
                deposits[i] = deposits[length - 1];
                // We do not need to remove the last deposit since we already copied it over
                // delete deposits[length - 1];
                // Shrink the array
                length --;
                deposits.length = length;
                // Also reduce the iterator by one so we stay here to process the deposit just moved here
                i--;
            }
        }
        if (balanceToWithdraw > 0) {
            sender.transfer(balanceToWithdraw);
        }
        return true;
    }
}