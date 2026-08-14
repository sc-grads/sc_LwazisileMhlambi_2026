-- 1. Create the Audit file destination
CREATE SERVER AUDIT [MyServerAudit] 
TO FILE ( FILEPATH = N'C:\SQLAuditLogs\' ); 
GO

-- 2. Enable the Audit
ALTER SERVER AUDIT [MyServerAudit] WITH (STATE = ON);
GO

-- 3. Create the Specification for Logins and Queries
CREATE SERVER AUDIT SPECIFICATION [MyAuditSpec]
FOR SERVER AUDIT [MyServerAudit]
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP),
ADD (SCHEMA_OBJECT_ACCESS_GROUP) -- Tracks SELECT/UPDATE/DELETE on objects
WITH (STATE = ON);
GO

CREATE TABLE dbo.AuditLogBridge (
    event_time DATETIME2,
    action_id VARCHAR(4),
    server_principal_name SYSNAME,
    database_name SYSNAME,
    object_name SYSNAME,
    statement NVARCHAR(MAX),
    succeeded BIT
);

Select *from AuditLogBridge

INSERT INTO dbo.AuditLogBridge
SELECT event_time, action_id, server_principal_name, database_name, object_name, statement, succeeded
FROM sys.fn_get_audit_file('C:\SQLAuditLogs\*.sqlaudit', DEFAULT, DEFAULT)
WHERE event_time > (SELECT ISNULL(MAX(event_time), '1900-01-01') FROM dbo.AuditLogBridge);
