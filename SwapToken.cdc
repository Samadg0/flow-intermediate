// Import SwapToken contract from version 0x05

transaction(amount: UFix64) {

    // Define the signer's account
    let signer: AuthAccount

    prepare(acct: AuthAccount) {
        self.signer = acct
    }

    execute {
        // Call the SwapToken contract to swap tokens
        SwapToken.swapTokens(signer: self.signer, swapAmount: amount)
        log("Swap successfully")
    }
}
