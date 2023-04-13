// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

contract ERC20_Tokne {
    string public _name;
    string public _symbol;
    uint8 public _decimal;
    uint256 public _total_supply;
    address[] public _contract_owner;

    mapping (address => uint256) balances ;
    mapping (address => mapping(address => uint256)) allowed ;

    event Approval (address _owner, address _spender, uint256 _value) ;
    event Transfer (address indexed _from, address indexed _to, uint256 _value) ;

    constructor() {
        _name = "Maktabkhoone_Solidity_Course" ;
        _symbol = "MSD" ;
        _decimal = 15 ;
        _total_supply = 1000000000 ;
        _contract_owner[0] = msg.sender ;
        _contract_owner[1] = 0x3222dcc091be80617bDE8F2CDAD50A5d42957A63 ;
        balances[_contract_owner[0]] = _total_supply / 2 ;
        balances[_contract_owner[1]] = _total_supply - balances[_contract_owner[0]] ;
    }

    function name () public view returns (string memory) {
        return _name ;
    }

    function symbol () public view returns (string memory) {
        return _symbol ;
    }

    function decimal () public view returns (uint8) {
        return _decimal ;
    }

    function totalsupply () public view returns(uint256) {
        return _total_supply ;
    }

    function balance_of (address _account) public view returns(uint256) {
        return balances[_account] ;
    }

    function allowence(address _owner, address _spender) public view returns(uint256){
          return allowed[_owner][_spender];
    }

    function approve (uint _which_contract_owner, address _spender, uint256 _value) public returns(bool){
        allowed[_contract_owner[_which_contract_owner]][_spender] = _value;
        emit Approval(_contract_owner[_which_contract_owner], _spender, _value);
        return true ;
    }

    function transfer (uint _which_contract_owner,address _to, uint256 _amount) public returns (bool) {
        require(_amount <= balances[_contract_owner[_which_contract_owner]]);
        balances[_contract_owner[_which_contract_owner]] -= _amount ;
        balances[_to] += _amount ;
        emit Transfer(_contract_owner[_which_contract_owner], _to, _amount);
        return true ;
    }

    function transferfrom(uint _which_contract_owner, address _from, address _to, uint256 _amount) public returns (bool){
        require(_amount <= balances[_from]);
        require(_amount <= allowed[_from][_contract_owner[_which_contract_owner]]);
        balances[_from] -= _amount;
        allowed[_from][_contract_owner[_which_contract_owner]] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
}
