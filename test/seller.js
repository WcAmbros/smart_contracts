const BigNumber = web3.BigNumber;

const should = require('chai')
    .use(require('chai-as-promised'))
    .use(require('chai-bignumber')(BigNumber))
    .should();


const Token = artifacts.require('Token')
const Seller = artifacts.require('Seller')

contract('Seller', ([owner, ownSeller, buyer]) => {
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


    it('except approve by promotion', async function () {

        const time = Math.round(new Date().getTime() / 1000)
        const startTime =  time - 100;
        const endTime = time + 300

        const cost = 1000
        const productId = 0
        const actionId = 0
        const amount = 300

        await sellerContract.addPromotion('Best Action!', 'http://tes.wq?qweq=12', startTime, endTime, {from: ownSeller})
        await tokenContract.payment(sellerContract.address, cost, productId, {from: buyer})
        await sellerContract.approveByPromotion(buyer, amount,actionId, {from: ownSeller}).should.be.fulfilled

        const {logs} = await tokenContract.transferFrom(sellerContract.address, buyer, amount, {from: buyer})
        const event = logs.find(e => e.event === 'Transfer')

        should.exist(event)
        event.args.from.should.equal(sellerContract.address)
        event.args.to.should.equal(buyer)
        event.args.value.should.bignumber.equal(amount)

    });

});
