//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';

import './TransferHelper.sol';

contract LaqiracePayment is Ownable {
    mapping(address => bool) private quoteToken;

    address private paymentReceiver;
    bool private nativeCurrencyPermit;

    event DepositToken(address player, address quoteToken, uint256 amount);
    event DepositNativeCurrency(address player, string curreny, uint256 amount);
    event WithdrawTokenRequest(address player, address quoteToken, uint256 amount);
    event WithdrawNativeRequest(address player, string currency, uint256 amount);

    function depositToken(address _quoteToken, address _player, uint256 _amount) public {
        require(quoteToken[_quoteToken], 'Payment method is not allowed');
        TransferHelper.safeTransferFrom(_quoteToken, _msgSender(), paymentReceiver, _amount);
        emit DepositToken(_player, _quoteToken, _amount);
    }

    function depositNativeCurrency(address _player) public payable {
        require(nativeCurrencyPermit, 'Payment method not allowed');
        emit DepositNativeCurrency(_player, 'BNB', msg.value);
    }

    function withdrawTokenRequest(address _quoteToken, uint256 _amount) public {
        emit WithdrawTokenRequest(_msgSender(), _quoteToken, _amount);
    }

    function withdrawNativeRequest(uint256 _amount) public {
        emit WithdrawNativeRequest(_msgSender(), 'BNB', _amount);
    }
}