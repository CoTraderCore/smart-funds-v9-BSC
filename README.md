# Run tests

```
NOTE: in separate console

0) npm i
1) npm run ganache  
2) truffle test
```

# TODO

```
1) Add more stables in permitted
2) Create new form for create v9 funds
```

# Updates
```
1) Add role swaper which can trade, pool and call defi protocols.
2) Fix manager take cut for case manager take cut on the best profit period when profit go up then go down.
3) Optimize gas (remove or cache global vars in functions), for funds with 5-10 and more tokens gas now in n x less.
4) Fund creator can change fund name.
5) Add any fund asset type.
```


# Possible issue

```
Exchange and Pool Portals v7 not has incompatibility with older versions,
so frontend should support different version of portals
```


# Mainent deploy note

```
Don't forget set new pool and exchange, portals, defi to permitted type storage
Don't forget add new addresses to new permittedAddresses contract
Don't forget set latest 1incg contract
```

# ADDRESSES

```
0.6.12+commit.27d51765

optimization true 200


DAI BSC

0x1af3f329e8be154074d8769d1ffa4ee058b1dbc3

Pancake Router

0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F


1inch Router

0x11111112542D85B3EF69AE05771c2dCCff4fAa26


1inch price rate

0xe26A18b00E4827eD86bc136B2c1e95D5ae115edD


ROOT

0x07596b59c8f5791b45713f921d0cabedc1d8012cd3eb1474552472735d476def


Permitted address

0x992F6c414A6DA6A7470dfB9D61eFc6639e9fbb0E


Merkle Root contract

0x3344573A8b164D9ed32a11a5A9C6326dDB3dC298


Tokens Type storage

0x666CAe17452Cf2112eF1479943099320AFD16d47

Price Portal

0x0D038FB3b78AEB931AC0A8d890F9E5A12A2b96B3


Pool Portal

0x2b4ba0A92CcC11E839d1928ae73b34E7aaC2C040


Defi Portal (NOT IMPLEMENTED)

0x6d85Dd4672AFad01a28bdfA8b4323bE910999954


New Exchange Portal

0x5f0b0f12718c256a0E172d199AA50F7456fd24AA


SmartFundETHFactory

0x9Ea1dC859Eb4D37Ce0a3a4940a96126de8547f4A


SmartFundERC20Factory



```
