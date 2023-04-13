// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;
import "./Safemath.sol" ;

contract Simple_Bank {

    address owner ;

    mapping (address => uint256) Balances ;
    event Deposit_Whithrawl(string _Transaction_Type) ;

    constructor() payable {
        owner = msg.sender ;
        Balances[owner] = msg.value ;
    }

    function Deposit (address _from, uint256 _amount) public returns(bool){
        require(Balances[_from] >= _amount,"your balance is not sufficient");
        Balances[_from] = safemath.subtraction(Balances[_from], _amount) ;
        Balances[owner] = safemath.sumation(Balances[owner], _amount ) ;
        emit Deposit_Whithrawl("Deposit");
        return true ;
    }

    function Withrawl (address _to, uint256 _amount) public returns(bool){
        require(Balances[owner] >= _amount,"your balance is not sufficient");
        Balances[owner] = safemath.subtraction(Balances[owner], _amount) ;
        Balances[_to] = safemath.sumation(Balances[_to], _amount ) ;
        emit Deposit_Whithrawl("Withrawl");
        return true ;
    }

    function balances (address _account) public view returns(uint256){
        return Balances[_account] ;
    }

}