import { useEffect } from "react";
import "./App.css"
function App() {

  useEffect(() => {
    const loadProvider = async () => {

      console.log(window.web3)
      console.log(window.ethereum)
    }
    loadProvider()
  }, [])
  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <div className="balance-view size-is-2">
            Current Balance: <strong>10</strong>ETH
          </div>
          <button 
            className="btn mr-2"
            onClick={async () => {
              const accounts = await window.ethereum.request({method: "eth_requestAccounts"})
              console.log(accounts)
            }}>
              Enable Ethereum
            </button>
          <button className="btn mr-2">Deposit</button>
          <button className="btn">Withdraw</button>
        </div>
      </div>
    </>
  );
}

export default App;
