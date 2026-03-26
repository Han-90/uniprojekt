import os
from azure.identity import DefaultAzureCredential
from azure.cosmos import CosmosClient


def get_container_client():
    endpoint = os.environ["COSMOS_ENDPOINT"]
    database_name = os.environ["COSMOS_DATABASE_NAME"]
    container_name = os.environ["COSMOS_CONTAINER_NAME"]

    credential = DefaultAzureCredential()
    client = CosmosClient(endpoint, credential=credential)

    database = client.get_database_client(database_name)
    container = database.get_container_client(container_name)
    return container