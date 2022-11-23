// SPDX-License-Identifier: unlicenced

pragma solidity ^0.8.7;

contract cryptoKids{
    // owner Dad
        address owner;

        event logKidFundingReceived(address addr, uint amount, uint contractBalance);

        constructor (){
            owner = msg.sender;

        }
        // define kid
        struct kid{
            address payable walletAddress;
            string firstname;
            string lastname;
            uint releaseTime;
            uint amount;
            bool canWithdraw;
        }

        kid[] public kids;
        modifier onlyOwner() {
            require(msg.sender == owner, "only owner can add kids");
            _;
        }

        // add kids to contract
        function addKid(address payable walletAddress, string memory firstName,string memory lastName,uint releaseTime,uint amount,bool canWithdraw)public onlyOwner{
            kids.push(kid(
                walletAddress,
                firstName,
                lastName,
                releaseTime,
                amount,
                canWithdraw
            ));
        }

        function balanceOf() public view returns(uint){
            return address(this).balance;
        }

        // deposit funds to the contract specifically to kids
        function deposit(address walletAddress) payable public {
            addToKidsBalance(walletAddress);
        }

        function addToKidsBalance(address walletAddress) private {
            for (uint i = 0; i < kids.length; i++) {
                if (kids[i].walletAddress == walletAddress) {
                    kids[1].amount += msg.value;
                    emit logKidFundingReceived(walletAddress,msg.value, balanceOf());
                }
            }
        }

        function getIndex(address walletAddress) view public returns(uint) {
            for (uint i=0; i < kids.length; i++) {
                if (kids[i].walletAddress == walletAddress) {
                    return i;
                }
            }
            return 999;
        }

         // kids check if they csn withdraw
        function availableForWithdraw(address walletAddress) public returns(bool) {
            uint i = getIndex(walletAddress);
            require(block.timestamp > kids[i].releaseTime, "you cannot withdraw yet");
            if(block.timestamp > kids[i].releaseTime) {
                kids[i].canWithdraw = true;
                return true;
            }else{
                return false;
            }
        }

        // withdraw
        function withdraw(address payable walletAddress) payable public {
            uint i = getIndex(walletAddress);
            require (msg.sender== kids[i].walletAddress,"you are not the kid" );
            require (kids[i].canWithdraw == true, "you are not able to withdraw");
            kids[i].walletAddress.transfer(kids[i].amount);
        }

    
    
    
   

}