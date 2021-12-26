import { BN, fromWei, toWei } from 'web3-utils'
import { MerkleTree } from 'merkletreejs'
import keccak256 from 'keccak256'
import ether from './helpers/ether'
import EVMRevert from './helpers/EVMRevert'
import { duration } from './helpers/duration'
import latestTime from './helpers/latestTime'
import advanceTimeAndBlock from './helpers/advanceTimeAndBlock'

const BigNumber = BN
const buf2hex = x => '0x'+x.toString('hex')

require('chai')
  .use(require('chai-as-promised'))
  .use(require('chai-bignumber')(BigNumber))
  .should()

const ETH_TOKEN_ADDRESS = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'

// real contracts
const ConvertPortal = artifacts.require('./core/platform_wallet/ConvertPortal.sol')
const PlatformWallet = artifacts.require('./core/platform_wallet/PlatformWallet.sol')

const UniswapV2Factory = artifacts.require('./dex/UniswapV2Factory.sol')
const UniswapV2Router = artifacts.require('./dex/UniswapV2Router02.sol')
const UniswapV2Pair = artifacts.require('./dex/UniswapV2Pair.sol')
const WETH = artifacts.require('./dex/WETH9.sol')

// mock
const Token = artifacts.require('./tokens/Token')

// Tokens keys converted in bytes32
const TOKEN_KEY_CRYPTOCURRENCY = "0x43525950544f43555252454e4359000000000000000000000000000000000000"
const DEAD_ADDRESS = "0x000000000000000000000000000000000000dEaD"

// Contracts instance
let xxxERC,
    DAI,
    permittedAddresses,
    uniswapV2Factory,
    uniswapV2Router,
    pairAddress,
    pair,
    weth,
    token,
    convertPortal,
    platformWallet



contract('Strategy UNI/WETH', function([userOne, userTwo, userThree]) {

  async function deployContracts(tokenLD=100, ethLD=100){
    token = await Token.new(
      "TOKEN",
      "TOKEN",
      18,
      "1000000000000000000000000"
    )

    // Deploy DAI Token
    DAI = await Token.new(
      "DAI Stable Coin",
      "DAI",
      18,
      "1000000000000000000000000"
    )

    // deploy DEX
    uniswapV2Factory = await UniswapV2Factory.new(userOne)
    weth = await WETH.new()
    uniswapV2Router = await UniswapV2Router.new(uniswapV2Factory.address, weth.address)

    // add token liquidity
    await token.approve(uniswapV2Router.address, toWei(String(tokenLD)))

    await uniswapV2Router.addLiquidityETH(
      token.address,
      toWei(String(tokenLD)),
      1,
      1,
      userOne,
      "1111111111111111111111"
    , { from:userOne, value:toWei(String(ethLD)) })

    // add token liquidity
    await DAI.approve(uniswapV2Router.address, toWei(String(tokenLD)))

    await uniswapV2Router.addLiquidityETH(
      DAI.address,
      toWei(String(tokenLD)),
      1,
      1,
      userOne,
      "1111111111111111111111"
    , { from:userOne, value:toWei(String(ethLD)) })

    pairAddress = await uniswapV2Factory.allPairs(0)
    pair = await UniswapV2Pair.at(pairAddress)

    convertPortal = await ConvertPortal.new(uniswapV2Router.address, weth.address)
    platformWallet = await PlatformWallet.new(convertPortal.address, token.address)
  }

  beforeEach(async function() {
    await deployContracts()
  })

  describe('Destribute', async function() {
    it('Destribute tokens works ', async function() {
      assert.equal(await DAI.balanceOf(platformWallet.address), 0)
      // send DAI to wallet
      await DAI.transfer(platformWallet.address, await DAI.balanceOf(userOne))
      assert.notEqual(await DAI.balanceOf(platformWallet.address), 0)

      assert.equal(await token.balanceOf(DEAD_ADDRESS), 0)
      // destribute
      await platformWallet.destributionTokens([DAI.address])
      assert.notEqual(await token.balanceOf(DEAD_ADDRESS), 0)
    })

    it('Destribute ETH works ', async function() {
      assert.equal(await web3.eth.getBalance(platformWallet.address), 0)

      // send ETH to wallet
      await platformWallet.sendTransaction({
        value: toWei(String(1)),
        from:userOne
      })

      assert.notEqual(await web3.eth.getBalance(platformWallet.address), 0)

      assert.equal(await token.balanceOf(DEAD_ADDRESS), 0)
      
      // destribute
      await platformWallet.destributionTokens([ETH_TOKEN_ADDRESS])

      assert.notEqual(await token.balanceOf(DEAD_ADDRESS), 0)
    })
  })
  //END
})
