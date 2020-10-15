#############################################################################
# Bash script using Azure CLI to create a document in CosmosDB
# Docs: https://docs.microsoft.com/en-us/rest/api/cosmos-db/create-a-document
#############################################################################

# This will trigger a browser-based login.
#az login

resourceGroup="AzureFunction"
comsosDbInstanceName="mkaesz-cosmos"
dbName="products"
containerName="clothes"
partitionKeyValue="asd123"
# If TRUE provided document can be created or updated automatically.
# If FALSE and an existing "id" is provided, there will be an error.
isUpsert=true
# JSON data to upload is stored in a file.
# Notes:
# - The "id" property is always required and must not be empty. If you don't have an ID, set it to a GUID.
# - When using the REST API, there must also be a property matching the partition key name with a value.
documentJson="create_document.json"


baseUrl="https://$comsosDbInstanceName.documents.azure.com/"
verb="post"
resourceType="docs"
resourceLink="dbs/$dbName/colls/$containerName/docs"
resourceId="dbs/$dbName/colls/$containerName"

az configure --defaults group=$resourceGroup

# URIs together with required parameter values can be found at: https://docs.microsoft.com/en-us/rest/api/cosmos-db/cosmosdb-resource-uri-syntax-for-rest

# Get the CosmosDB's master key. We need this to get access.
# This is the same key that can be found on the portal in the "Keys" section of the CosmosDB instance. The primary key is what the REST API refers to as the "master" key.
masterKey=$(az cosmosdb keys list --name $comsosDbInstanceName --query primaryMasterKey --output tsv)
echo "Masterkey: $masterKey"

# CosmosDB REST API requires a hashed authorization header: https://docs.microsoft.com/de-de/rest/api/cosmos-db/access-control-on-cosmosdb-resources#authorization-header

# To get date in HTTP format, locale must be set to US. Otherwise day names would be localized (to German, for example)
# HTTP format is not directly supported by bash. To make it work, set the current timezone to GMT.
now=$(env LANG=en_US TZ=GMT date '+%a, %d %b %Y %T %Z')
echo "Date: " $now

# Concat verb, resource type, resource ID and date in the expected format. REST API expects the signature to be lowercase.
# The "little" problem I was not aware of: trailing newlines (`\n`) are always truncated when outputting a string.
# This would break the hash, because CosmosDB expects them to be there. That's why the two trailing newlines are appended back after the lowercase operation.
signature="$(printf "%s" "$verb\n$resourceType\n$resourceId\n$now" | tr '[A-Z]' '[a-z]')\n\n"
echo "Signature: $signature"

# Calculate a hash of the signature using the primary key of the CosmosDB instance.
# See https://superuser.com/questions/1546027/what-is-the-openssl-equivalent-of-this-given-c-hashing-code/1546036 for details on why
# this is so tricky.
hexKey=$(printf "$masterKey" | base64 --decode | hexdump -v -e '/1 "%02x"')
echo "Hex key: " $hexKey
hashedSignature=$(printf "$signature" | openssl dgst -sha256 -mac hmac -macopt hexkey:$hexKey -binary | base64)
echo "Hashed signature: $hashedSignature"

# Build the authorization header using the format "type={typeoftoken}&ver={tokenversion}&sig={hashsignature}"
authString="type=master&ver=1.0&sig=$hashedSignature"
echo "Auth string: $authString"

# Auth string is expected to be URL encoded. But of course there's no built-in way in bash to do that. Geez.
# This is not a full base64 encoding but instead only changes the characters we may see: = -> %3d, & -> %26, + => %2b, / => %2f
urlEncodedAuthString=$(printf "$authString" | sed 's/=/%3d/g' | sed 's/&/%26/g' | sed 's/+/%2b/g' | sed 's/\//%2f/g')
echo "URL encoded auth string: $urlEncodedAuthString"

# Make the API call by combining base URL and resource link.
url="$baseUrl$resourceLink"
echo "URL: $url"

az rest --verbose -m $verb -b "@$documentJson" -u $url --headers x-ms-date="$now" x-ms-documentdb-partitionkey=[\"$partitionKeyValue\"] x-ms-documentdb-is-upsert=$isUpsert x-ms-version=2018-12-31 x-ms-documentdb-isquery=true Content-Type=application/json Authorization=$urlEncodedAuthString

# Alternative: use cUrl
#curl --request $verb --data "@$documentJson" -H "x-ms-documentdb-is-upsert: $isUpsert" -H "x-ms-documentdb-partitionkey: [\"default\"]" -H "x-ms-date: $now" -H "x-ms-version: 2018-12-31" -H "Content-Type: application/json" -H "Authorization: $urlEncodedAuthString" $url

