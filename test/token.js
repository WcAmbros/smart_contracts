const BigNumber = web3.BigNumber;

const should = require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();


const Token = artifacts.require('Token')
const Seller = artifacts.require('Seller')

contract('Token', ([owner, ownSeller, buyer]) => {
    let tokenContract = null
    let sellerContract = null
    let defAmount = 10000

    beforeEach(async function () {
        tokenContract = await Token.new()
        sellerContract = await Seller.new(tokenContract.address, {from: ownSeller})

        await tokenContract.transfer(ownSeller, defAmount)
        await tokenContract.transfer(buyer, defAmount)

        await tokenContract.addSeller(sellerContract.address, {from: ownSeller})
    });

    it('except payment by buyer', async function () {
        const cost = 1000
        const productId = 10

        const {logs} = await tokenContract.payment(sellerContract.address, cost, productId, {from: buyer})

        const event = logs.find(e => e.event === 'Payment')
        should.exist(event)

        event.args.from.should.equal(buyer)
        event.args.seller.should.equal(sellerContract.address)
        event.args.ownSeller.should.equal(ownSeller)
        event.args.value.should.bignumber.equal(cost)
        event.args.productId.should.bignumber.equal(productId)
    });


    it('except transfer token from seller to ownSeller', async function () {
        const cost = 1000
        const amount = 1000
        const productId = 10

        await tokenContract.payment(sellerContract.address, cost, productId, {from: buyer})
        await tokenContract.transferFromSeller(sellerContract.address, amount, {from: ownSeller}).should.be.fulfilled
    });


});
