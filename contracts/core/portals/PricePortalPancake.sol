import "../interfaces/IDecimals.sol";
import "../../zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../uniswap/interfaces/IUniswapV2Router.sol";

interface Router {
  function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

interface Factory {
  function getPair(address tokenA, address tokenB) external view returns (address pair);
}


contract PricePortalPancake {
  address public WETH;
  address public router;
  address public factory;
  address[] public connectors;

  constructor(
    address _WETH,
    address _router,
    address _factory,
    address[] memory _connectors
  )
    public
  {
    WETH = _WETH;
    router = _router;
    factory = _factory;
    connectors = _connectors;
  }

  // helper for get ratio
  function getPrice(
    address _from,
    address _to,
    uint256 _amount
  )
    external
    view
    returns (uint256 value)
  {
    if(_amount > 0){
      // if direction the same, just return amount
      if(_from == _to)
         return _amount;

      // WRAP ETH token with weth
      address wrapETH = WETH;

      address fromAddress = _from == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
      ? wrapETH
      : _from;

      address toAddress = _to == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
      ? wrapETH
      : _to;

      // if pair exits get rate between this pair
      if(Factory(factory).getPair(fromAddress, toAddress) != address(0)){
        address[] memory path = new address[](2);
        path[0] = fromAddress;
        path[1] = toAddress;

        return routerRatio(path, _amount);
      }
      // else get connector
      else{
        address connector = findConnector(_to);
        require(connector != address(0), "0 connector");
        address[] memory path = new address[](3);
        path[0] = fromAddress;
        path[1] = connector;
        path[2] = toAddress;

        return routerRatio(path, _amount);
      }
    }
    else{
      return 0;
    }
  }

  // helper for find connector
  function findConnector(address _to)
    public
    view
    returns (address connector)
  {
    // cache storage vars in memory for safe gas
    address _factoryCached = factory;
    uint256 _lengthCached = connectors.length;

    for(uint i =0; i< _lengthCached; i++){
      address pair = Factory(_factoryCached).getPair(_to, connectors[i]);
      if(pair != address(0))
         return connectors[i];
    }

    return address(0);
  }

  // helper for get price from router
  function routerRatio(address[] memory path, uint256 fromAmount)
    public
    view
    returns (uint256)
  {
    uint256[] memory res = Router(router).getAmountsOut(fromAmount, path);
    return res[1];
  }
}
