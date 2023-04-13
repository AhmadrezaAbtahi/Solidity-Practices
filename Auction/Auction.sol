// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.6 <0.9.0;

contract Auction {
    uint public maxBid;
    address public owner;
    bool public closed;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    struct Bid {
        address payable bidder;
        uint amount;
    }    

    Bid[] public bids;
    uint public maximum;

    constructor() {
        owner = msg.sender;
        maxBid = 0;
        maximum = 0;
        closed = false;
    }

    function bid() public payable {
        require(!closed, "The auction closed!");
        require(msg.value > maxBid, "The bid is not high enough");

        bids.push(Bid(payable(msg.sender), msg.value));
        maxBid = msg.value;
        maximum = bids.length - 1;

        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function auctionEnd() public returns(address) {
        require(!closed, "The auction is already closed!");
        require(msg.sender == owner, "Only the owner can close the auction");

        closed = true;
        if(bids.length == 0){
            return address(0);
        } else {
            for(uint i = 0; i < bids.length; i++){
                if(i != maximum){
                    bids[i].bidder.transfer(1 wei * bids[i].amount);
                }
            }

            emit AuctionEnded(bids[maximum].bidder, maxBid);
            return bids[maximum].bidder;
        }
    }

    function cancelation() public {
        require(!closed, "The auction is already closed!");
        for (uint i = 0; i < bids.length; i++) {
            if (bids[i].bidder == msg.sender) {
                uint canceledAmount = bids[i].amount;
                if (i == maximum) {
                    maximum = 0;
                    maxBid = 0;
                    for (uint j = 0; j < bids.length; j++) {
                        if (bids[j].amount > maxBid) {
                            maxBid = bids[j].amount;
                            maximum = j;
                        }
                    }
                }
                bids[i] = bids[bids.length - 1];
                bids.pop();
                payable(msg.sender).transfer(1 wei * canceledAmount);
                break;
            }
        }
    }
}
