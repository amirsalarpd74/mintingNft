# Minting NFT

# Task
Create a minting page for the contract. I dont care so much about design *asuming you will be able to make things look
a design in the future. But what I would like to see if good user feedback.
UI should give clear indication to things such as waiting for a traction to finish and a nice 
notification that there mint has successes/failed.
Page just needs a button in the center `Connect wallet` which would then change to `mint` after



# Requirements
Display remaining mints such as xx/xx

Functions:
- getMaxSupply()
- getRemainingMints()

Display mint price in eth
Functions:
- getMintPrice() # returns in gwei

Display status if sale has started. If the mint hasnt started then mint button should be disabled
If sale has started only enable mint button if user is on whitelist using `getOnWhiteList(address)` if not display a
message to let them know they are not on the whitelist
Once public enabled show it and enable mint button for all

Functions:
- getSaleStarted() # premint
- getOpenToPublic() # public 
- getOnWhiteList(address)

If user has minted disable button and give message Mint allowance exceeded or whatever

Functions: 
- getHasMinted(address)

Lastly allow users to mint

Functions:
- safeMint()
