const axios = require('axios');
const ethers = require('ethers');
require('dotenv').config();

module.exports = async function getFirstTransaction (address) {
    console.time()
    console.log(process.env.MY_API_KEY);

   //  const address = '0xc5102fE9359FD9a28f877a67E36B0F050d81a3CC'
    
   //  await axios.get(`https://api.etherscan.io/api?module=account&action=txlist&address=${address}&startblock=0&endblock=15759804&page=1&offset=1&sort=asc&apikey=${process.env.MY_API_KEY}`)
   //       .then(function(response){
   //          const firstTimestamp = response.data.result[0].timeStamp;
   //          console.log(firstTimestamp)
   //       })
   //       .catch(function(error){
   //          console.log(error)
   //       })
   return 1645264949;
   console.timeLog();
}