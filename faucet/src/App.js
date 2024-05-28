import { useEffect, useState } from "react";
import "./App.css"
import Web3 from "web3";
import { provider } from "ganache";
import detectEthereumProvider from "@metamask/detect-provider";

function App() {

  const [web3Api, setWeb3Api] = useState({
    provider: null,
    web3: null
  })

  const [account, setAccounts] = useState(null)

  useEffect(() => {
    const loadProvider = async () => {
      const provider = await detectEthereumProvider()

      if(provider) {
        setWeb3Api({
          web3: new Web3(provider),
          provider
        })
      } else {
        console.log("Please, install Metamask.")
      }
    
    }
    loadProvider()
  }, [])

useEffect(() => {
  const getAccount = async () => {
    const accounts = await web3Api.web3.eth.getAccounts()
    setAccounts(accounts[0])
  }

  web3Api.web3 && getAccount()
}, [web3Api.web3])

  return (

    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <span>
            <strong>Account: </strong>
          </span>
          <h1>
            { account ? account : "Not connected"}
          </h1>
          <div className="balance-view is-size-2">
            Current Balance: <strong>10</strong> ETH
          </div>
          
          <button className="btn mr-2">Donate</button>
          <button className="btn">Withdraw</button>
        </div>
      </div>
    </>
  );
}

export default App;
