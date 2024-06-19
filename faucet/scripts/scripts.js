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

    console.log(`Deployed Contract at: ${tokenMaster.address}\n`)

    const occasions = [
        {
            name: "KPL Nairobi",
            cost: tokens(1),
            tickets: 0,
            date: "July 19",
            time: "6:15PM EAT",
            location: "Nyayo Stadium - Nairobi"
        },

        {
            name: "SolFest Tour",
            cost: tokens(3),
            date: "Dec 30 - 1st",
            time: "7:00PM",
            location: "Uhuru Gardens - Nairobi"
        },

        {
            name: "Victoria Kimani Tour",
            cost: tokens(3),
            date: "Dec 30 - 1st",
            time: "7:00PM",
            location: "Uhuru Gardens - Nairobi"
        },

        {
            name: "Fally Kenya Tour",
            cost: tokens(3),
            date: "Dec 30 - 1st",
            time: "7:00PM",
            location: "Uhuru Gardens - Nairobi"
        },

    ]

    for (let i = 0; i < array.length; i++) {
        const transaction = await tokenMaster.connect(deployer).list(
            occasions[i].name,
            occasions[i].cost,
            occasions[i].tickets,
            occasions[i].date,
            occasions[i].time,
            occasions[i].location,
        )
        await transaction.wait()

        console.log(`Listed Event ${i + 1}: ${occasions[i].name}`)

    }
}