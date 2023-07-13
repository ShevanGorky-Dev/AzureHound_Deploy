$containerName = "azurehound"
$resourceGroupName = "RGcontainer"
$image = "azurehound.azurecr.io/latest:latest"
$restartPolicy = "Never"
$environmentVariables = @{
    "AZ_STORAGE_ACCOUNT" = "acistorage123345"
    "AZ_STORAGE_CONTAINER" = "acicontainer123345"
}
$cpu = 4
$memory = 8
$assignIdentity = "[system]"

az container create `
    --name $containerName `
    --resource-group $resourceGroupName `
    --image $image `
    --restart-policy $restartPolicy `
    --environment-variables $environmentVariables `
    --cpu $cpu `
    --memory $memory `
    --assign-identity $assignIdentity