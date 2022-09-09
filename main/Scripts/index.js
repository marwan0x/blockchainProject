const express = require('express')
const Web3 = require("web3");
const NFTABI = require("./NFTABI");
const Provider = require("@truffle/hdwallet-provider");
const NFTMarketABI = require("./NFTMarketABI");
const infuraURL = "https://rinkeby.infura.io/v3/c94ec4db34064ca6b2073c9f354c4756";
const privateKey = "39201cf21a6eafe707f8be5230e38ee333d236cdfee124baab4c5da8fae9535c";
const app = express()
const port = 3000
var NFTMarket;
var NFT;
var itemsCounter = 0;

console.log(NFTABI);
console.log(NFTMarketABI);

var NFTMarketAddress = "0x01daDAD06040e8d42B047411c9c1e82ABc74176A";
var NFTAddress = "0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8";
var provider = new Provider(privateKey, infuraURL);
const web3 = new Web3(provider);

NFTMarket = new web3.eth.Contract(NFTMarketABI, NFTMarketAddress);
NFT = new web3.eth.Contract(NFTABI, NFTAddress);


app.get('/', (req, res) => {
    setNftContract(NFTAddress);
    // var tokenId = createToken("ape");
    // console.log(tokenId);
    // createMarketItem(tokenId, 1);
    var allItems = showAllItems();
    res.send(allItems)
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})

function createToken(tokenURI){
    return NFT.methods.createToken(tokenURI).call();
}

function createMarketItem(tokenId, price){
    itemsCounter++;
    return NFTMarket.methods.createMarketItem(tokenId, price).send({from: "0x5c29a9B2Bda4ac6Ad84F67DF9F6e8980eBF595eD",  "value": 1 });
}

function MarketItems(itemId){
    return NFTMarket.methods.MarketItems(itemId).call({from: "0x5c29a9B2Bda4ac6Ad84F67DF9F6e8980eBF595eD"});
}
function setNftContract(address){
    return NFTMarket.setNftContract(address).send();
}
function showAllItems(){
    var result =[];
    for(var i =0; i<itemsCounter; i++){
        result[i] = MarketItems(i);
    }
    return result;
}


