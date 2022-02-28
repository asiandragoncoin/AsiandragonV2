pragma solidity >=0.6.2 <0.8.0;

import "./Ownable.sol";
import "./TeamToken.sol";

contract TeamTokenFactory is Ownable{
    address[] public allTeamTokens;
    address public feeWallet;

    event TeamTokenCreated(address indexed token, string indexed name, string indexed symbol, uint8 decimals, uint256 supply);



    modifier checkIsAddressValid(address ethAddress)
    {
        require(ethAddress != address(0), "[Validation] invalid address");
        require(ethAddress == address(ethAddress), "[Validation] invalid address");
        _;
    }


    constructor(address _feeWallet) public checkIsAddressValid(_feeWallet){
        feeWallet = _feeWallet;
    }

    function setFeeWallet(address _feeWallet) public onlyOwner checkIsAddressValid(_feeWallet){
        feeWallet = _feeWallet;
    }

    function createTeamToken(string calldata _name, string calldata _symbol, uint8 _decimals, uint256 _supply) external returns (address) {
        require(_decimals >=8 && _decimals <= 18, "Not valid decimals");
    
        TeamToken token = new TeamToken(_name, _symbol, _decimals, _supply, msg.sender, feeWallet);
        allTeamTokens.push(address(token));

        emit TeamTokenCreated(address(token), _name, _symbol, _decimals, _supply);           
        return address(token);
    }

    function allTeamTokensLength() external view returns (uint256) {
        return allTeamTokens.length;
    }
}
