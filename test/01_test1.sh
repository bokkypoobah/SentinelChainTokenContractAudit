#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

TOKENSRC=`grep ^TOKENSRC= settings.txt | sed "s/^.*=//"`
TOKENSOL=`grep ^TOKENSOL= settings.txt | sed "s/^.*=//"`
TOKENJS=`grep ^TOKENJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

printf "MODE            = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD        = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR       = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "TOKENSRC        = '$TOKENSRC'\n" | tee -a $TEST1OUTPUT
printf "TOKENSOL        = '$TOKENSOL'\n" | tee -a $TEST1OUTPUT
printf "TOKENJS         = '$TOKENJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA  = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS       = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT     = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS    = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
`cp $SOURCEDIR/$TOKENSRC $TOKENSOL`

solc_0.4.21 --version | tee -a $TEST1OUTPUT

echo "var tokenOutput=`solc_0.4.21 --optimize --pretty-json --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS


geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:SencToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:SencToken"].bin;

// console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
// console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));

unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokenMessage = "Deploy Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployTokenMessage + " ----------");
var tokenContract = web3.eth.contract(tokenAbi);
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: var tokenAddress=\"" + tokenAddress + "\";");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(tokenTx, deployTokenMessage);
printTxData("tokenAddress=" + tokenAddress, tokenTx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var mintTokensMessage = "Mint Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + mintTokensMessage + " ----------");
var mintTokens_1Tx = token.mint(account4, new BigNumber("100").shift(18), {from: contractOwnerAccount, gas: 400000});
var mintTokens_2Tx = token.mint(account5, new BigNumber("200").shift(18), {from: contractOwnerAccount, gas: 400000});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(mintTokens_1Tx, mintTokensMessage + " - mint 100 tokens for ac4");
failIfTxStatusError(mintTokens_2Tx, mintTokensMessage + " - mint 200 tokens for ac5");
printTxData("mintTokens_1Tx", mintTokens_1Tx);
printTxData("mintTokens_2Tx", mintTokens_2Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var completeSetupMessage = "Complete Setup";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + completeSetupMessage + " ----------");
var completeSetup_1Tx = token.finishMinting({from: contractOwnerAccount, gas: 400000});
var completeSetup_2Tx = token.unpause({from: contractOwnerAccount, gas: 400000});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(completeSetup_1Tx, completeSetupMessage + " - finishMinting()");
failIfTxStatusError(completeSetup_2Tx, completeSetupMessage + " - unpause()");
printTxData("completeSetup_1Tx", completeSetup_1Tx);
printTxData("completeSetup_2Tx", completeSetup_2Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveTokensMessage = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + moveTokensMessage + " ----------");
var moveTokens1Tx = token.transfer(account6, new BigNumber("1").shift(18), {from: account4, gas: 100000, gasPrice: defaultGasPrice});
var moveTokens2Tx = token.approve(account7, new BigNumber("2").shift(18), {from: account5, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var moveTokens3Tx = token.transferFrom(account5, account8, new BigNumber("2").shift(18), {from: account7, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(moveTokens1Tx, moveTokensMessage + " - transfer 1 tokens ac4 -> ac6");
failIfTxStatusError(moveTokens2Tx, moveTokensMessage + " - approve 2 tokens ac5 -> ac7");
failIfTxStatusError(moveTokens3Tx, moveTokensMessage + " - transferFrom 2 tokens ac5 -> ac8 by ac7");
printTxData("moveTokens1Tx", moveTokens1Tx);
printTxData("moveTokens2Tx", moveTokens2Tx);
printTxData("moveTokens3Tx", moveTokens3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveZeroTokensMessage = "Move Zero Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + moveZeroTokensMessage + " ----------");
var moveZeroTokens1Tx = token.transfer(account6, 0, {from: account4, gas: 100000, gasPrice: defaultGasPrice});
var moveZeroTokens2Tx = token.approve(account7, 0, {from: account5, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var moveZeroTokens3Tx = token.transferFrom(account5, account8, 0, {from: account7, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(moveZeroTokens1Tx, moveZeroTokensMessage + " - transfer 0 tokens ac4 -> ac6");
failIfTxStatusError(moveZeroTokens2Tx, moveZeroTokensMessage + " - approve 0 tokens ac5 -> ac7");
failIfTxStatusError(moveZeroTokens3Tx, moveZeroTokensMessage + " - transferFrom 0 tokens ac5 -> ac8 by ac7");
printTxData("moveZeroTokens1Tx", moveZeroTokens1Tx);
printTxData("moveZeroTokens2Tx", moveZeroTokens2Tx);
printTxData("moveZeroTokens3Tx", moveZeroTokens3Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveTooManyTokensMessage = "Move Too Many Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + moveTooManyTokensMessage + " ----------");
var moveTooManyTokens1Tx = token.transfer(account6, new BigNumber("1000").shift(18), {from: account4, gas: 100000, gasPrice: defaultGasPrice});
var moveTooManyTokens2Tx = token.approve(account7, new BigNumber("2000").shift(18), {from: account5, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var moveTooManyTokens3Tx = token.transferFrom(account5, account8, new BigNumber("2000").shift(18), {from: account7, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
passIfTxStatusError(moveTooManyTokens1Tx, moveTooManyTokensMessage + " - transfer 1,000 tokens ac4 -> ac6 - expecting failure");
failIfTxStatusError(moveTooManyTokens2Tx, moveTooManyTokensMessage + " - approve 2,000 tokens ac5 -> ac7");
passIfTxStatusError(moveTooManyTokens3Tx, moveTooManyTokensMessage + " - transferFrom 2,000 tokens ac5 -> ac8 by ac7 - expecting failure");
printTxData("moveTooManyTokens1Tx", moveTooManyTokens1Tx);
printTxData("moveTooManyTokens2Tx", moveTooManyTokens2Tx);
printTxData("moveTooManyTokens3Tx", moveTooManyTokens3Tx);
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
