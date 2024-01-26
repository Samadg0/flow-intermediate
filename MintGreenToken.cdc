// Import FungibleToken and GreenToken from version 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the GreenToken Minter reference
        let minter = signer.borrow<&GreenToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not the GreenToken minter")
        
        // Borrow the receiver's GreenToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&GreenToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your GreenToken Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's GreenToken Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("GreenToken minted and deposited successfully")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}
