# National Hospital Data Engineering Project

## Overview
National Hospital is leveraging Azure cloud technologies to enhance healthcare research and patient care through data analytics.

## Objectives
1. Design a dimensional data model (OLAP) for the hospital.
2. Load the data to Azure Blob Storage.
3. Create a Datawarehouse with STG and EDW schemas.
4. Build a pipeline on Azure Data Factory.
5. Transform and load data into the EDW schema.
6. Test the Datawarehouse with queries.
7. Schedule daily refresh of the Datawarehouse.
8. Recommend process optimizations.

## Project Structure
- **docs/**: Documentation and diagrams.
- **data/**: Raw and transformed data.
- **scripts/**: Ingestion, transformation, validation scripts, and test queries.
- **azure/**: Azure-specific configurations and pipeline definitions.
- **config/**: Configuration files.

## Getting Started
1. Clone the repository.
2. Set up the Azure environment.
3. Configure your credentials in `.env`.
4. Run the data ingestion script: `python scripts/ingest_data.py`.
5. Execute the pipeline in Azure Data Factory.
6. Validate the data: `python scripts/validate_data.py`.


# Steps 
1. Conceptual Stage : Meeting with Business Team, Software teams, Project Managers, Data Team, other Stakeholders.

Goal is to identify stakeholders needs and outline scope of the project.
2. Gather requirements and define the project objectives. It is very important that the objectives address the business needs and provides solution to the business problems.
3. Design a dimensional data model (OLAP) in accordance to the business needs and the OLTP ERD design or schema of the business
4. Create a Resource group on Azure to host all services needed for the project. Create a tag to track all services relating to the project as well.
5. Create a storage account on azure within the resource group for the project

In choosing your `Redundancy`, the Locally-redundant storage (LRS) will back up your data in the same data center region you are using for the project , in my case `(Europe) UK West`. 
Geo-Redundant storage (GRS): will back up your data in your local region and also in another secondary region.
LRS is cost effective and should be considered maybe during development. Choice of redundancy will depend on the project and the data being backed-up 
Zone-redundant storage (ZRS) will back it up in a different zone within the same region.
Geo-zone-redundant storage(GZRS) combines both zone- and geo-redundant storage and it is the most expensive which is mostly used for critical data

NB: Coosing between Blob Storage and ADLS : The difference is Blob storage DOES NOT have 'Heirachical Namespace' while ADLS have.
`Heirachical namespace` simply means a folder(directory) structure. In Blob storage, all the data is just there in one storage but ADLS can have folders for each classification of data.
For proper structuring and directory semantics, heirachical namespace is enabled , which means we are using ADLS and not Blob Storage.

NB: Network selection is another thing: In development, you can enable public access but in producion, companies Use private access or virtual network and IP address 


6. Create a container in the ADLS named`source` indicating where the source files or raw files will be stored.

7. You can either upload the source files manually or use the python script to fetch and drop the data in the container.

If you are a consultant, it is common that the client will most likely drop the source files in a container for you.
So the ADLS container can be business-phasing or client-phasing by exposing it to the client or business so they can always drop source file in the container for you.
Your pipeline can then be configured to pick it up from there.

For this project, i am using a data ingestion script `ingest_data.py`that uploads the source files in to container 

Get `AZURE_CONNECTION_STRING` from 'Access and Access Keys' in your container 'security + networking'

8. Create a SQL Dtabase with two schema. STG FOR staging raw data (BRONZE STAGE) and EDW for Enterprise or business ready data (GOLD STAGE)

NB: Ensure it is within the same resource group for the project for better classification  

Select server or create a new one : We will be using Microsoft Entra Autehtication because it allows centralized Identity Management and more secure for production usage.
Additionally, it can integrate with on-premises Active Directory and other SaaS applications.

For full capability; log in the SQL Database on `Azure Data Studio` otherwise the cacapibities from the query editor is limited

9. With the resource group for the project, create another resource `Azure Data Factory` which will be used to build the pipeline for this project.

SSIS is more like a legacy version of ADF, so we used ADF for this project since client is moving to the cloud and moving away from on-prem.


10. Link ADF to your repository either on AzureDevOps or Github

# The ELTL Pipeline Configuration on Azure Data Factory (ADF)

The pipeline is an ETLT :

i. Extraction : Copy source file ingested into the Azure Data Lake Storage container with the ingestion script

The `source` is the Datasets in `Azure Data Lake Storage Gen2` Container and where we are copying or extracting to is the `sink`, in this case, `SQL Database`

- Timeout, Retry, and Retry intervals can be configured with respect to the amount of data expected to be copied to avoid wasting resources
- Define the linked service : which basically defines connection parameters ADF activity needs to authenticate itself when connecting to an external data source.
- 

Here are the names for all the source datasets:

- Patients Dataset: `src_patients_DS`
- Medical Records Dataset: `src_medical_records_DS`
- Imaging Results Dataset: `src_imaging_DS`
- Lab Results Dataset: `src_lab_results_DS`
- Trials Dataset: `src_trials_DS`
- Participants Dataset: `src_participants_DS`
- Doctors Dataset: `src_doctors_DS`
- Departments Dataset: `src_departments_DS`
- Appointments Dataset: `src_appointments_DS`

NB: If you are using system managed Authentication for your SQL Database Linked service, it is important to grant access to ADF instance 
This can be done by creating a user using the ADF instance name, and Granting the reqiured priviledes as specified in [SQL_access_to_ADF.sql](sql%2FSQL_access_to_ADF.sql)
NB: When selecting your runtime, `AutoResolveIntegrationRuntime` works when your source is with azure or Azure Storage. if you are extracting or pulling the data on-prem or outside Azure platform, you need to create a configured Integration Runtime(IR) using file downloaded after the configuration. 
- Validate after each dataset is added to the pipeline and debug 

ii. Transformation: The stored procedure is configured to load data from the staging schema to the Enterprise data warehouse while performing transformation and 
logging the stored procedure activities in the pipeline.

the `DATE_CTE` primarily serves to consolidate and standardize date information for the dim_date table, 
while also contributing to some optimization in terms of reduced redundancy and improved query maintainability.

iii. Loading : The transformed data loaded into the EDW schema is ready to use for production, and the pipeline is configured to store aggregates in production schemas of different departments of the organization for further analysis, visualization and reports.




