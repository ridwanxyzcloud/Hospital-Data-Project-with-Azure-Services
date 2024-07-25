-- Create User using the ADF managed instance name
-- Then GRANT privilege as db_owner
CREATE USER [hospitalprojectADF] FROM EXTERNAL PROVIDER;
ALTER ROLE db_owner ADD MEMBER [hospitalprojectADF];

-- You can equally grant only the needed privilege, which is read and write

CREATE USER [hospitalprojectADF] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [hospitalprojectADF];
ALTER ROLE db_datawriter ADD MEMBER [hospitalprojectADF];


