// Import FungibleToken and GreenToken from version 0x05
import FungibleToken from 0x05
import GreenToken from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &GreenToken.Vault{FungibleToken.Balance, 
    FungibleToken.Receiver, GreenToken.VaultInterface}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&GreenToken.Vault{FungibleToken.Balance, 
            FungibleToken.Receiver, GreenToken.VaultInterface}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- GreenToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&GreenToken.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver, GreenToken.VaultInterface}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &GreenToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&GreenToken.Vault{FungibleToken.Balance}>()
        log("Balance of the new vault: ")
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &GreenToken.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver, GreenToken.VaultInterface} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&GreenToken.Vault{FungibleToken.Balance, 
                FungibleToken.Receiver, GreenToken.VaultInterface}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if GreenToken.vaults.contains(checkVault.uuid) {     
            log("Balance of the existing vault:")       
            log(publicVault?.balance)
            log("This is a GreenToken vault")
        } else {
            log("This is not a GreenToken vault")
        }
    }
}
