pragma solidity ^0.6.12;

contract MockExchangePortalPrice {
  function getValue(address _from, address _to, uint256 _amount)
   external
   view
   returns (uint256)
  {
    return 0;
  }

  function getTotalValue(
    address[] calldata _fromAddresses,
    uint256[] calldata _amounts,
    address _to)
    external
    view
    returns (uint256)
  {
    return 0;
  }
}
