// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

library safemath {

    function sumation (uint a, uint b) public pure returns (uint){
        require ( a + b >= a , "your result is lower than one of your parameter") ;
        require ( a + b >= b , "your result is lower than one of your parameter") ;
        return a + b ;
    }
    function subtraction (uint a, uint b) public pure returns (uint){
        require(a >= 0 ,"your input is nagative(must not be)");
        require (b >= 0, "your input is nagative(must not be)");
        require(a - b >= 0 , "your result is nagative(must not be)");
        return a - b ;
    }
}