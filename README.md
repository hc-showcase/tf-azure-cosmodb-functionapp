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

```
### Build the Zip

The Zip file must contain the functions and the host.json file in the root. It must not container a root folder.

The Zip must look like that:
```
mkaesz@arch ~/w/tf-azure-cosmodb-functionapp (master)> unzip -l dist.zip
Archive:  dist.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2020-10-15 20:29   CosmosDBTrigger/
      193  2020-10-15 20:10   CosmosDBTrigger/__init__.py
      370  2020-10-15 20:29   CosmosDBTrigger/function.json
      288  2020-10-15 16:53   host.json
      109  2020-10-15 16:53   requirements.txt
---------                     -------
      960                     5 files

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

Execute terraform and wait. In my case it took up to 25 minutes until the CosmosDB was created. Redeploying the function is done in 1 or 2 minutes.

```
terraform init

terraform apply

```

### Insert a document

The repository contains a shell script to create documents. The values of the db, collection, etc. are hard-coded in the script and align with the Terraform config.

The script is from https://github.com/Krumelur/AzureScripts

```
mkaesz@arch ~/w/tf-azure-cosmodb-functionapp (master)> bash cosmosdb_create_document.sh
Masterkey: M30N2tOr9iQnXBH0lZNCAi3FFW8Ne2dyuPkBB5rpYp4Hkd1GeNRS88C0QE0Ae8WI01x75brre8U2UKtFdL9K5g==
Date:  Thu, 15 Oct 2020 18:45:24 GMT
Signature: post\ndocs\ndbs/products/colls/clothes\nthu, 15 oct 2020 18:45:24 gmt\n\n
Hex key:  337d0ddad3abf624275c11f4959342022dc5156f0d7b6772b8f901079ae9629e0791dd4678d452f3c0b4404d007bc588d35c7be5baeb7bc53650ab4574bf4ae6
Hashed signature: tQ4DkLl8E9suwklREMV7QaNHhBuoS1Igc30YeBTp+u8=
Auth string: type=master&ver=1.0&sig=tQ4DkLl8E9suwklREMV7QaNHhBuoS1Igc30YeBTp+u8=
URL encoded auth string: type%3dmaster%26ver%3d1.0%26sig%3dtQ4DkLl8E9suwklREMV7QaNHhBuoS1Igc30YeBTp%2bu8%3d
URL: https://mkaesz-cosmos.documents.azure.com/dbs/products/colls/clothes/docs
Request URL: 'https://mkaesz-cosmos.documents.azure.com/dbs/products/colls/clothes/docs'
Request method: 'POST'
Request headers:
    'User-Agent': 'AZURECLI/2.13.0'
    'Accept-Encoding': 'gzip, deflate'
    'Accept': '*/*'
    'Connection': 'keep-alive'
    'x-ms-date': 'Thu, 15 Oct 2020 18:45:24 GMT'
    'x-ms-documentdb-partitionkey': '["asd123"]'
    'x-ms-documentdb-is-upsert': 'true'
    'x-ms-version': '2018-12-31'
    'x-ms-documentdb-isquery': 'true'
    'Content-Type': 'application/json'
    'Authorization': 'type%3dmaster%26ver%...'
    'x-ms-client-request-id': '82abdd7b-7c32-4ae8-a184-76f24c236fc0'
    'CommandName': 'rest'
    'ParameterSetName': '--verbose -m -b -u --headers'
    'Content-Length': '75'

Request body:
{  
    "id": "1qweasd23",
    "clothesId": "asd123",
    "name": "socks"
}
Response status: 201
Response headers:
    'Cache-Control': 'no-store, no-cache'
    'Pragma': 'no-cache'
    'Transfer-Encoding': 'chunked'
    'Content-Type': 'application/json'
    'Server': 'Microsoft-HTTPAPI/2.0'
    'Strict-Transport-Security': 'max-age=31536000'
    'x-ms-last-state-change-utc': 'Thu, 15 Oct 2020 17:54:58.484 GMT'
    'etag': '"0d00243a-0000-0d00-0000-5f8898c50000"'
    'x-ms-resource-quota': 'documentSize=51200;documentsSize=52428800;documentsCount=-1;collectionSize=52428800;'
    'x-ms-resource-usage': 'documentSize=0;documentsSize=2;documentsCount=7;collectionSize=4;'
    'lsn': '62'
    'x-ms-schemaversion': '1.10'
    'x-ms-alt-content-path': 'dbs/products/colls/clothes'
    'x-ms-content-path': '0UFmAMBvPOg='
    'x-ms-quorum-acked-lsn': '61'
    'x-ms-current-write-quorum': '3'
    'x-ms-current-replica-set-size': '4'
    'x-ms-xp-role': '1'
    'x-ms-global-Committed-lsn': '61'
    'x-ms-number-of-read-regions': '1'
    'x-ms-transport-request-id': '1'
    'x-ms-cosmos-llsn': '62'
    'x-ms-cosmos-quorum-acked-llsn': '61'
    'x-ms-session-token': '0:0#62#27=-1'
    'x-ms-request-charge': '6.29'
    'x-ms-serviceversion': 'version=2.11.0.0'
    'x-ms-activity-id': 'c694e569-4a0e-4189-beaa-fc96dc4319eb'
    'x-ms-gatewayversion': 'version=2.11.0'
    'Date': 'Thu, 15 Oct 2020 18:45:24 GMT'
Response content:
{"id":"1qweasd23","clothesId":"asd123","name":"socks","_rid":"0UFmAMBvPOiIhB4AAAAAAA==","_self":"dbs\/0UFmAA==\/colls\/0UFmAMBvPOg=\/docs\/0UFmAMBvPOiIhB4AAAAAAA==\/","_etag":"\"0d00243a-0000-0d00-0000-5f8898c50000\"","_attachments":"attachments\/","_ts":1602787525}
{
  "_attachments": "attachments/",
  "_etag": "\"0d00243a-0000-0d00-0000-5f8898c50000\"",
  "_rid": "0UFmAMBvPOiIhB4AAAAAAA==",
  "_self": "dbs/0UFmAA==/colls/0UFmAMBvPOg=/docs/0UFmAMBvPOiIhB4AAAAAAA==/",
  "_ts": 1602787525,
  "clothesId": "asd123",
  "id": "1qweasd23",
  "name": "socks"
}
Command ran in 0.577 seconds (init: 0.067, invoke: 0.511)
```

### Check the results

In the Azure Portal look at the details of your function:

![Screenshot](/images/screenshot-logs.png)
