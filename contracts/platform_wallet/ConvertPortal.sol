import "../uniswap/interfaces/IUniswapV2Router.sol";
import "../zeppelin-solidity/contracts/token/ERC20/IERC20.sol";

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
   returns(uint256)
  {
    // ETH case
    if(_from == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
      address[] memory path = new address[](2);
      path[0] = WETH;
      path[1] = _to;

      router.swapExactETHForTokens.value(_amount)(
        1,
        path,
        address(this),
        now + 15 minutes
      );
    }
    // ERC20 case
    else {
      address[] memory path = new address[](2);
      path[0] = _from;
      path[1] = _to;

      _transferFromSenderAndApproveTo(IERC20(_from), _amount, address(router));

      router.swapExactTokensForTokens(
         _amount,
         1,
         path,
         address(this),
         now + 15 minutes
       );
    }

    uint256 received = IERC20(_to).balanceOf(address(this));
    IERC20(_to).transfer(msg.sender, received);

    return received;
  }

  function _transferFromSenderAndApproveTo(IERC20 _source, uint256 _sourceAmount, address _to) private {
    require(_source.transferFrom(msg.sender, address(this), _sourceAmount));
    _source.approve(_to, _sourceAmount);
  }
}
