import hre from 'hardhat'

const tokens = (n) => {
    return ethers.parseUnits(n.toString(), 'ethet')
}

async function main() {
    const [deployer] = await eithers.getSigners()
    const NAME = 'TokenMaster'
    const SYMBOL = 'TM'

    const TokenMaster = await ethers.getContractFactory('TokenMaster')
    const tokenMaster = await TokenMaster.deploy(NAME, SYMBOL)
    await tokenMaster.deployed()
}