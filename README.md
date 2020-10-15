# tf-azure-functionapp

This repo creates a Azure Function app and deploys a Zip file containing a Python application. The Zip file has to be created upfront and stored locally.

## Install tools

* Azure CLI
* Terraform
* 7z

## Login to Azure

Execute ```az login``` and follow the instructions in your browser or ```az login -h``` to see other ways to login.

## Clone this repo

```
mkaesz@arch ~/workspace> git clone git@github.com:hc-showcase/tf-azure-functionapp.git
Cloning into 'tf-azure-functionapp'...
Warning: Permanently added 'github.com,140.82.121.3' (RSA) to the list of known hosts.
remote: Enumerating objects: 39, done.
remote: Counting objects: 100% (39/39), done.
remote: Compressing objects: 100% (30/30), done.
remote: Total 39 (delta 15), reused 27 (delta 7), pack-reused 0
Receiving objects: 100% (39/39), 14.22 KiB | 14.22 MiB/s, done.
Resolving deltas: 100% (15/15), done.

mkaesz@arch ~/workspace> cd tf-azure-functionapp/

```
### Build the Zip

The Zip file must contain the functions and the host.json file in the root. It must not container a root folder.

The Zip must look like that:
```
mkaesz@arch ~/w/tf-azure-functionapp (main)> unzip -l dist.zip
Archive:  dist.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2020-10-13 11:42   HttpExample/
      751  2020-10-13 11:41   HttpExample/__init__.py
        0  2020-10-13 11:42   HttpExample/__pycache__/
      865  2020-10-13 11:42   HttpExample/__pycache__/__init__.cpython-38.pyc
      314  2020-10-13 11:41   HttpExample/function.json
      288  2020-10-13 11:41   host.json
      117  2020-10-13 11:41   local.settings.json
      109  2020-10-13 11:41   requirements.txt
---------                     -------
     2444                     8 files

```

To build the Zip I used 7z:
```
mkaesz@arch ~/w/tf-azure-functionapp (main)> 
7z a dist.zip ./functions/*

7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=en_US.UTF-8,Utf16=on,HugeFiles=on,64 bits,24 CPUs AMD Ryzen 9 3900X 12-Core Processor             (870F10),ASM,AES-NI)

Open archive: dist.zip
--
Path = dist.zip
Type = zip
Physical Size = 2717

Scanning the drive:
2 folders, 6 files, 2444 bytes (3 KiB)

Updating archive: dist.zip

Items to compress: 8

    
Files read from disk: 6
Archive size: 2717 bytes (3 KiB)
Everything is Ok
```

The repository already contains a dist.zip that can be immediately be used without the build step.

### Set your Subscription ID

In main.tf you have to specify the subscription ID you want to use.

### Execute Terraform

```
mkaesz@arch ~/w/tf-azure-functionapp (main)> terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/azurerm...
- Finding latest version of hashicorp/random...
- Installing hashicorp/azurerm v2.31.1...
- Installed hashicorp/azurerm v2.31.1 (signed by HashiCorp)
- Installing hashicorp/random v3.0.0...
- Installed hashicorp/random v3.0.0 (signed by HashiCorp)

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/azurerm: version = "~> 2.31.1"
* hashicorp/random: version = "~> 3.0.0"

Terraform has been successfully initialized!



mkaesz@arch ~/w/tf-azure-functionapp (main)> terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

...

Plan: 9 to add, 0 to change, 0 to destroy.



mkaesz@arch ~/w/tf-azure-functionapp (main)> terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:

Terraform will perform the following actions:

...

Plan: 9 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_string.storage_name: Creating...
random_string.app_service_plan_name: Creating...
random_string.function_name: Creating...
random_string.app_service_plan_name: Creation complete after 0s [id=2R3Z7KHYQRIcY64K]
random_string.storage_name: Creation complete after 0s [id=zsskq9eyggqyimle]
random_string.function_name: Creation complete after 0s [id=qi2fam3952tkdkha]
azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Creation complete after 1s [id=/subscriptions/02d0e06b-ed9d-4ca5-bb9f-0a0243a9c9f2/resourceGroups/AzureFunction]
azurerm_app_service_plan.plan: Creating...
azurerm_storage_account.storage: Creating...
azurerm_app_service_plan.plan: Creation complete after 6s [id=/subscriptions/02d0e06b-ed9d-4ca5-bb9f-0a0243a9c9f2/resourceGroups/AzureFunction/providers/Microsoft.Web/serverfarms/2R3Z7KHYQRIcY64K]
azurerm_storage_account.storage: Still creating... [10s elapsed]
azurerm_storage_account.storage: Still creating... [20s elapsed]
azurerm_storage_account.storage: Creation complete after 22s [id=/subscriptions/02d0e06b-ed9d-4ca5-bb9f-0a0243a9c9f2/resourceGroups/AzureFunction/providers/Microsoft.Storage/storageAccounts/zsskq9eyggqyimle]
data.azurerm_storage_account_sas.storage_sas: Reading...
azurerm_storage_container.storage_container: Creating...
data.azurerm_storage_account_sas.storage_sas: Read complete after 0s [id=8f1e254b53e26fbc7288f45999847f558665f12a0ec1208ab4a83b90ea5959b6]
azurerm_storage_container.storage_container: Creation complete after 0s [id=https://zsskq9eyggqyimle.blob.core.windows.net/func]
azurerm_storage_blob.storage_blob: Creating...
azurerm_storage_blob.storage_blob: Creation complete after 0s [id=https://zsskq9eyggqyimle.blob.core.windows.net/func/dist.zip]
azurerm_function_app.function: Creating...
azurerm_function_app.function: Still creating... [10s elapsed]
azurerm_function_app.function: Still creating... [20s elapsed]
azurerm_function_app.function: Still creating... [30s elapsed]
azurerm_function_app.function: Still creating... [40s elapsed]
azurerm_function_app.function: Still creating... [50s elapsed]
azurerm_function_app.function: Still creating... [1m0s elapsed]
azurerm_function_app.function: Creation complete after 1m2s [id=/subscriptions/02d0e06b-ed9d-4ca5-bb9f-0a0243a9c9f2/resourceGroups/AzureFunction/providers/Microsoft.Web/sites/zsskq9eyggqyimle]

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.
```

### Execute the function

Go to Azure Portal Login and to your function. Get the URL from there. I couldn't find a way to get the URL from Azure's CLI.
