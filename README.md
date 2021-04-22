# Pascal-FMX-Wallet
Cryptocurrency wallet for the Pascal blockchain (PascalCoin) From UrbanCohort


Copyright (c) 2016-2021 PascalCoin developers based on original Albert Molina source code

This version is copyright (c) 2019-2021 Russell Weetch, subject to the above copyright
  
THIS IS EXPERIMENTAL SOFTWARE. Use it for educational purposes only.  
    
Distributed under the MIT software license, see the accompanying file  
LICENSE  or visit http://www.opensource.org/licenses/mit-license.php.  


## Introduction ##

To keep to the spirit of PascalCoin this is a Wallet for PascalCoin developed in Delphi Firemonkey and uses the PascalCoin JSON RPC for on chain actions. It has been developed in Delphi (10.4) Sydney but I've not used any of the 10.3 language enhancements (like inline variables) so it should be fine with Seattle and Berlin. 

Using Firemonkey means that the wallet can be built for Windows 32 & 64, Mac OSX, Android and iOS.

I've stuck to core Delphi where I can (I'd rather have used XSuperObject for JSON, but I have persevered with System.JSON and REST.JSON). There are a few places where I have needed external libraries such as the crypto libraries written for PascalCoin, TFrameStand (which really should be part of Delphi by now)

Documentation has been added using Documentation InSight from DevJet. It's easy enoungh to copy the layout required.


## Dependencies ##

- UrbanCohort PascalCoin RPC-Client: https://github.com/UrbanCohortDev/PascalCoin-RPC-Client
- SimplebaseLib4Pascal: https://github.com/Xor-el/SimpleBaseLib4Pascal
- HashLib4Pascal: https://github.com/Xor-el/HashLib4Pascal
- CryptoLib4Pascal: https://github.com/xor-el/cryptoLib4Pascal/
- FrameStand: available via GetIt package manager or at https://github.com/andrea-magni/TFrameStand

Note that for SimpleBaseLib, HashLib and CryptoLib the *UrbanCohort PascalCoin-RPC-Client Repo* contains an application (Applications/DevTools) that will enable you to either
- create single folders of the source which you can then map into the project
- add the source paths to Delphi's Global Search Path (preffered) 


## Languages ##

The aim is to have the project support multiple languages. The current state of play is to use a place holder Object
