interface IConvertPortal {
  function convert(
    address _from,
    address _to,
    uint _amount
  )
   external
   payable
   returns(uint256);
}
