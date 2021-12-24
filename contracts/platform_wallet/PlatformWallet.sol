pragma solidity ^0.6.12;

import "../zeppelin-solidity/contracts/access/Ownable.sol";

contract PlatformWallet is Ownable {
  address public COT;
  address public partnerAddress;

  uint cotSplit = 50;
  uint partnerSplit = 0;
  uint platformSplit = 50;


  function convertAndBurn(
    address _fromToken,
    address _toToken,
    uint256 _amount
  )
  internal
  {

  }

  function setSplit(
    uint _cotSplit,
    uint _partnerSplit,
    uint _platformSplit
  )
    external
    onlyOwner
  {
    uint totalPercent = _cotSplit + _partnerSplit + _platformSplit;
    require(totalPercent == 100, "Wrong total %");
    cotSplit = _cotSplit;
    partnerSplit = _partnerSplit;
    platformSplit = _platformSplit;
  }
}
