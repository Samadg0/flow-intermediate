// Import FungibleToken and GreenToken from version 0x05

transaction(receiverAccount: Address, amount: UFix64) {

    // Define references for the sender's and receiver's vaults
    let signerVault: &GreenToken.Vault
    let receiverVault: &GreenToken.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        // Borrow references and handle errors
        self.signerVault = acct.borrow<&GreenToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Sender's vault missing")

        self.receiverVault = getAccount(receiverAccount)
            .getCapability(/public/Vault)
            .borrow<&GreenToken.Vault{FungibleToken.Receiver}>()
            ?? panic("Receiver's vault missing")
    }

    execute {
        // Withdraw tokens from the sender's vault and deposit them into the receiver's vault
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: amount))
        log("Tokens successfully transferred")
    }
}
