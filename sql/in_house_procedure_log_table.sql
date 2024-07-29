CREATE TABLE STG.procedure_logs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    runtime DATETIME NOT NULL,
    status NVARCHAR(10) NOT NULL,
    error_msg NVARCHAR(MAX) NULL
