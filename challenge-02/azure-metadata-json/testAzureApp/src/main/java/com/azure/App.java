package com.azure.testAzureApp;
import org.json.*;

public class App 
{
    public static void main( String[] args )
    {
   try {
            TokenCredential credential = new DefaultAzureCredentialBuilder()
                    .authorityHost(AzureAuthorityHosts.AZURE_PUBLIC_CLOUD)
                    .build();

            AzureProfile profile = new AzureProfile(AzureEnvironment.AZURE);

            AzureResourceManager azureResourceManager = AzureResourceManager.configure()
                    .withLogLevel(HttpLogDetailLevel.BASIC)
                    .authenticate(credential, profile)
                    .withDefaultSubscription();

            VirtualMachine vm = azure.virtualMachines().getByResourceGroup("tech-challenge-rg", "web-vm");
            
            //TODO - format output in json 
            JSONObject jsonObj = new JSONObject(vm);

            // Use the print statements and keys to fetch the desired metadata values.
            System.out.println("    vmSize: " + vm.size());
            System.out.println("    publisher: " + vm.storageProfile().imageReference().publisher());
            System.out.println("    sku: " + vm.storageProfile().imageReference().sku());
            System.out.println("    version: " + vm.storageProfile().imageReference().version());
            System.out.println("    osType: " + vm.storageProfile().osDisk().osType());
            System.out.println("    name: " + vm.storageProfile().osDisk().name());
            for (InstanceViewStatus status : vm.instanceView().statuses()) {
            System.out.println("  code: " + status.code());
            System.out.println("  displayStatus: " + status.displayStatus());
}
     } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
}

}