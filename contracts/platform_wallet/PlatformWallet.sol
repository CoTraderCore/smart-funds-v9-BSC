pragma solidity ^0.6.12;

import "../zeppelin-solidity/contracts/access/Ownable.sol";
import "../zeppelin-solidity/contracts/token/IERC20";
import "./IConvertPortal"

contract PlatformWallet is Ownable {
  address public COT;
  address public partnerAddress;
  IConvertPortal public convertPortal;

  uint cotSplit = 50;
  uint partnerSplit = 0;
  uint platformSplit = 50;

  constructor(address _convertPortal) public {
    convertPortal = IConvertPortal(_convertPortal);
  }

  function destribution(address[] memory tokens) external {

  }

  function convertAndBurn(
    address _fromToken,
    address _toToken,
    uint256 _amount
  )
  internal
  {
    uint256 recieved = convertPortal(_fromToken, _toToken, _amount);
    IERC20(_toToken).transfer(0x000000000000000000000000000000000000dEaD);
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

  function senConvertPortal(address _convertPortal) external {
    convertPortal = IConvertPortal(_convertPortal);
  }
}
