// Import FungibleToken and GreenToken contracts from version 0x05
import FungibleToken from 0x05
import GreenToken from 0x05

// Create Green Token Vault Transaction
transaction() {

    // Define references
    let userVault: &GreenToken.Vault{FungibleToken.Balance, 
        FungibleToken.Provider, 
        FungibleToken.Receiver, 
        GreenToken.VaultInterface}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow the vault capability and set the account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&GreenToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, GreenToken.VaultInterface}>()
        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- GreenToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&GreenToken.Vault{FungibleToken.Balance, 
                FungibleToken.Provider, 
                FungibleToken.Receiver, 
                GreenToken.VaultInterface}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created")
        } else {
            log("Vault already exists and is linked")
        }
    }
}
