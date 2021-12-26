pragma solidity ^0.6.12;

import "../zeppelin-solidity/contracts/access/Ownable.sol";
import "../zeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../zeppelin-solidity/contracts/math/SafeMath.sol";
import "./IConvertPortal.sol";

contract PlatformWallet is Ownable {
  using SafeMath for uint;

  address public COT;
  address public partnerTokenAddress;
  IConvertPortal public convertPortal;

  uint cotSplit = 50;
  uint partnerSplit = 0;
  uint platformSplit = 50;

  constructor(address _convertPortal, address _COT) public {
    convertPortal = IConvertPortal(_convertPortal);
    COT = _COT;
  }

  // destribute tokens
  function destributionTokens(address[] memory tokens) external {
    address ETH_TOKEN = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    for(uint i = 0; i < tokens.length; i++){
       uint totalBalance = tokens[i] == ETH_TOKEN
       ? address(this).balance
       : IERC20(tokens[i]).balanceOf(address(this));

       // convert and burn COT
       uint cotSplitAmount = totalBalance.div(100).mul(cotSplit);
       if(cotSplitAmount > 0)
         convertAndBurn(tokens[i], COT, cotSplitAmount);

       // convert and burn Partner token
       uint partnerSplitAmount = totalBalance.div(100).mul(partnerSplit);
       if(partnerSplitAmount > 0)
         convertAndBurn(
           tokens[i],
           partnerTokenAddress,
           partnerSplitAmount
         );

       // transfer to platform
       uint platformSplitAmount = totalBalance.div(100).mul(platformSplit);
       if(platformSplitAmount > 0)
         // ETH case
         if(tokens[i] == ETH_TOKEN){
           payable(owner()).transfer(platformSplitAmount);
         }
         // ERC20 case
         else{
           IERC20(tokens[i]).transfer(owner(), platformSplitAmount);
         }
     }
  }

  // helpers

  function convertAndBurn(
    address _fromToken,
    address _toToken,
    uint256 _amount
  )
  internal
  {

    uint256 recieved;

    if(_fromToken == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)){
      recieved = convertPortal.convert.value(_amount)(_fromToken, _toToken, _amount);
    }else{
      IERC20(_fromToken).approve(address(convertPortal), _amount);
      recieved = convertPortal.convert(_fromToken, _toToken, _amount);
    }
    IERC20(_toToken).transfer(0x000000000000000000000000000000000000dEaD, recieved);
  }


  // ONLY owner setters
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

  function senConvertPortal(address _convertPortal) external onlyOwner {
    convertPortal = IConvertPortal(_convertPortal);
  }

  function senPartnerToken(address _partnerTokenAddress) external onlyOwner {
    partnerTokenAddress = _partnerTokenAddress;
  }

  receive() external payable  {}
}
