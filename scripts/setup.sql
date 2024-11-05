/***************************************************************************************************
     
Quickstart:   LLM Assisted Medical Coding Extraction for Healthcare
Version:      v1
Author:       Kala Govindarajan
Copyright(c): 2024 Snowflake Inc. All rights reserved.
****************************************************************************************************
SUMMARY OF CHANGES
Date(yyyy-mm-dd)    Author              Comments
------------------- ------------------- ------------------------------------------------------------
2024-10-28          Kala Govindarajan      Initial Release
***************************************************************************************************/

--STEP 1 Setup Database, Schema, role, warehouse and tables

USE ROLE SYSADMIN;

/*--
 Database, schema and warehouse creation
--*/

-- create a CFT database
CREATE OR REPLACE DATABASE HEALTHCARE_REPORTS_DB;

CREATE OR REPLACE SCHEMA REPORTS_SCHEMA;
CREATE OR REPLACE WAREHOUSE reports_WH WAREHOUSE_SIZE='Medium' AUTO_SUSPEND = 60;


CREATE OR REPLACE NETWORK RULE allow_all_rule
MODE= 'EGRESS'
TYPE = 'HOST_PORT'
VALUE_LIST = ('0.0.0.0:443','0.0.0.0:80');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION allow_all_integration
ALLOWED_NETWORK_RULES = (allow_all_rule)
ENABLED = true;
-- create roles
USE ROLE securityadmin;

-- functional roles

CREATE ROLE IF NOT EXISTS CFT_ROLE COMMENT = 'Fine tuning role';
GRANT ROLE CFT_ROLE TO role SYSADMIN;

--Grants
USE ROLE securityadmin;

GRANT USAGE ON DATABASE HEALTHCARE_REPORTS_DB TO ROLE CFT_ROLE;
GRANT USAGE ON ALL SCHEMAS IN DATABASE HEALTHCARE_REPORTS_DB TO ROLE CFT_ROLE;

GRANT ALL ON SCHEMA HEALTHCARE_REPORTS_DB.REPORTS_SCHEMA TO ROLE CFT_ROLE;

GRANT ALL ON SCHEMA HEALTHCARE_REPORTS_DB.PUBLIC TO ROLE CFT_ROLE;


-- future grants
GRANT ALL ON FUTURE TABLES IN SCHEMA HEALTHCARE_REPORTS_DB.REPORTS_SCHEMA TO ROLE CFT_ROLE;



use role SYSADMIN;
GRANT ALL ON WAREHOUSE reports_WH TO ROLE CFT_ROLE;
GRANT USAGE ON INTEGRATION allow_all_integration TO ROLE CFT_ROLE;
GRANT CREATE MODEL ON SCHEMA REPORTS_SCHEMA TO ROLE CFT_ROLE;


USE ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE CFT_ROLE;

