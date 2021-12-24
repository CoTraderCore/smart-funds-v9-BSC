import "../uniswap/interfaces/IUniswapV2Router";

contract ConvertPortal {
  IUniswapV2Router public router;
  address public WETH;

  constructor(address _router, address _WETH) public {
    router = IUniswapV2Router(_router);
    WETH = _WETH;
  }

  function convert(
    address _from,
    address _to,
    uint _amount
  )
   external
   payable
  {
    // ETH case
    if(_from == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
      address[] memory path = new address[](2);
      path[0] = WETH;
      path[1] = _to;

      router.swapExactETHForTokens.value(_amount)(
        1,
        path,
        msg.sender,
        now + 15 minutes
      );
    }
    // ERC20 case
    else {
      address[] memory path = address[](2);
      path[0] = _from;
      path[1] = _to;

      _transferFromSenderAndApproveTo(_from,  _amount, address(router));

      router.swapExactTokensForTokens(
         _amount,
         1,
         path,
         msg.sender,
         now + 15 minutes
       );
    }
  }

  function _transferFromSenderAndApproveTo(ERC20 _source, uint256 _sourceAmount, address _to) private {
    require(_source.transferFrom(msg.sender, address(this), _sourceAmount));
    _source.approve(_to, _sourceAmount);
  }
}
