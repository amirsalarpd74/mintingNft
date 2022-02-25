from brownie import accounts, NftCollection, NftLibs, exceptions
import pytest

@pytest.fixture
def nft_collection():
    accounts[0].deploy(NftLibs)
    return accounts[0].deploy(NftCollection)

def test_account_balance():
    balance = accounts[0].balance()
    accounts[0].transfer(accounts[1], "10 ether", gas_price=0)

    assert balance - "10 ether" == accounts[0].balance()

def test_create_tocke_correctly(nft_collection):
    nft_collection.createToken("Image_1", accounts[1].address, "convert image to ipfs")
    max_supply =  nft_collection.getMaxSupply()
    remaining_mints = nft_collection.getRemainingMints()

    assert max_supply == 1
    assert remaining_mints == 1

def test_only_owner_could_change_public_show_state(nft_collection):
    owner = accounts[0]
    customer = accounts[1]

    nft_collection.setOpenToPublic({'from' : owner})

    assert nft_collection.getOpenToPublic({'from' : owner}) == True

    nft_collection.setClosedToPublic({'from' : owner})

    assert nft_collection.getOpenToPublic({'from' : owner}) == False

    with pytest.raises(exceptions.VirtualMachineError):
        nft_collection.setOpenToPublic({'from' : customer})

    assert nft_collection.getOpenToPublic({'from' : customer}) == False

    with pytest.raises(exceptions.VirtualMachineError):
        nft_collection.setClosedToPublic({'from' : customer})

    assert nft_collection.getOpenToPublic({'from' : customer}) == False

def test_only_owner_could_add_on_white_list(nft_collection):
    owner = accounts[0]
    customer_1 = accounts[1]
    customer_2 = accounts[2]

    customer_address = accounts[1].address
    customer_address_2 = accounts[2].address

    assert nft_collection.getOnWhiteList({'from' : customer_1}) == False 

    nft_collection.addToWhiteList(customer_address, {'from' : owner})

    assert nft_collection.getOnWhiteList({'from' : customer_1}) == True

    with pytest.raises(exceptions.VirtualMachineError):
        nft_collection.addToWhiteList(customer_address_2, {'from' : customer_1})

    assert nft_collection.getOnWhiteList({'from' : customer_2}) == False 

def test_if_account_1_has_image_and_has_minimum_gas_then_contract_should_convert_image_to_nft(nft_collection):
    owner_balance = accounts[0].balance()
    customer_balance = accounts[1].balance()

    nft_collection.setOpenToPublic({'from':accounts[0]})

    nft_collection.createToken("Image_1", accounts[1].address, "convert image to ipfs", {'from':accounts[1]})
    nft_collection.safeMint({'from':accounts[1], 'value':'1 ether'})

    assert owner_balance + "0.000001 ether" == accounts[0].balance()
    assert customer_balance >= accounts[1].balance() + "0.000001 ether"

def test_if_account_1_has_not_image_and_has_minimum_gas_then_contract_should_not_convert_image_to_nft(nft_collection):
    owner_balance = accounts[0].balance()

    with pytest.raises(exceptions.VirtualMachineError):
        nft_collection.safeMint({'from':accounts[1], 'value':'1 ether'})

    assert owner_balance == accounts[0].balance()

def test_if_account_1_has_image_and_has_not_minimum_gas_then_contract_should_not_convert_image_to_nft(nft_collection):
    owner_balance = accounts[0].balance()

    nft_collection.createToken("Image_1", accounts[1].address, "convert image to ipfs", {'from':accounts[1]})

    with pytest.raises(exceptions.VirtualMachineError):
        nft_collection.safeMint({'from':accounts[1]})

    assert owner_balance == accounts[0].balance()