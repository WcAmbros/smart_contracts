module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
    networks:{
        development:{
            host:"127.0.0.1",
            port:7545,
            network_id:5777
        },
        /*rinkeby: {
            host: "localhost",
            port: 8545,
            network_id: "4", // Rinkeby ID 4
            from: "0xda452cf1D0478d1f202c92D3Ee16907E3f6ad643", // account from which to deploy
            gas: 6712390
        }*/
    }
};
