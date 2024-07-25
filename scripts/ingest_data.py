import os
from azure.storage.blob import BlobServiceClient
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv(override=True)

# Get the values from the environment variables
connection_string = os.getenv("AZURE_CONNECTION_STRING")
container_name = os.getenv("AZURE_CONTAINER_NAME")
local_directory = os.getenv("SOURCE_LOCAL_DIRECTORY")

# Initialize the BlobServiceClient
blob_service_client = BlobServiceClient.from_connection_string(connection_string)
container_client = blob_service_client.get_container_client(container_name)

# Create the source container if it does not exist
try:
    container_client.create_container()
except Exception as e:
    print(f"Container already exists or could not be created: {e}")

# Function to upload files
def upload_files_to_adls(local_directory, container_client):
    for root, dirs, files in os.walk(local_directory):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            blob_path = os.path.relpath(file_path, local_directory).replace("\\", "/")

            print(f"Uploading {file_path} to {blob_path}")

            # Create a BlobClient for the file
            blob_client = container_client.get_blob_client(blob_path)

            # check files already exist in container
            if not blob_client.exists():
                print(f"Uploading {file_path} to {blob_path}")
            # Upload the file
                with open(file_path, "rb") as data:
                    blob_client.upload_blob(data, overwrite=True)
            else:
                print(f"File {blob_path} already exist. Skipping upload....")

# Upload the files from the local directory to ADLS
upload_files_to_adls(local_directory, container_client)

print("Upload completed successfully.")
