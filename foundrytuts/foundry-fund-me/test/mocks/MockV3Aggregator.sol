// SPDX-License-Identifier: MIT

contract MockV3Aggregator {
    int256 public constant version = 0;

    uint8 public decimals;
    uint256 public latestRoundAnswer;
    

    constructor(int256 _price) {
        price = _price;
    }

    function decimals() public pure returns (uint8) {
        return 8;
    }

    function latestRoundData()
        public
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (0, price, 0, 0, 0);
    }
}