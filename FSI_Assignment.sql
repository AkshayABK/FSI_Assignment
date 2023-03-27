CREATE or replace DATABASE CARINSURANCEDatabase;

use carinsurancedatabase;

Create or replace schema CarInsuranceSchema;

use schema CarInsuranceSchema;

create or replace TABLE CARINSURANCEDatabase.CarInsuranceSchema.CARINSURANCETABLE (
	ID NUMBER(38,0),
	KIDSDRIV NUMBER(38,0),
	BIRTH DATE,
	HOMEKIDS NUMBER(38,0),
	YOJ NUMBER(38,0),
	INCOME NUMBER(38,0),
	PARENT1 VARCHAR(10),
	HOME_VAL NUMBER(38,0),
	MSTATUS VARCHAR(10),
	GENDER VARCHAR(10),
	EDUCATION VARCHAR(30),
	OCCUPATION VARCHAR(30),
	TRAVTIME NUMBER(38,0),
	CAR_USE VARCHAR(20),
	BLUEBOOK NUMBER(38,0),
	CAR_TYPE VARCHAR(20),
	OLDCLAIM NUMBER(38,0),
	CLM_FREQ NUMBER(38,0),
	CLM_AMT NUMBER(38,0),
	CAR_AGE NUMBER(38,0),
	URBANICITY VARCHAR(30)
);


CREATE OR REPLACE FILE FORMAT my_csv_format
  type = CSV
  compression = 'none'
  field_delimiter = ','
  skip_header = 1 ;


COPY INTO CARINSURANCEDatabase.carInsuranceschema.CARINSURANCETABLE
	FROM @~/customer/csv/uncompressed/CarInsuranceData.csv
	file_format = my_csv_format
	on_error = 'CONTINUE'
	PURGE = true;


select * from carinsurancetable LIMIT 10;

CREATE ROLE FSI_ROLE;

CREATE USER root password='password' default_role = myrole must_change_password = true;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE FSI_ROLE;

GRANT USAGE ON DATABASE CARINSURANCEDATABASE TO ROLE FSI_ROLE;

GRANT SELECT ON ALL TABLES IN SCHEMA CARINSURANCEDATABASE.CARINSURANCESCHEMA to role FSI_ROLE;

GRANT ROLE FSI_ROLE TO USER ROOT;


----------------------------------------------------------Assignment  02-------------------------------------------------------------
USE carinsurancedatabase;
Use Schema CARINSURANCESCHEMA;

--Car avg Income--
create or replace procedure AvgCarValueProcedure()
returns table()
language sql
as
declare
    res RESULTSET DEFAULT (create or replace table Avg_Car_Value_Table as select row_number() over (order by car_type) as Index,Car_type, round(avg(BLUEBOOK),2) as AVERAGE_CAR_COST from CARINSURANCETABLE group by CAR_TYPE);
begin
    return table(res);
end;

call AvgCarValueProcedure();

select * from AVG_CAR_VALUE_TABLE;

--Json--
create or replace table json_table02(bluebook variant);

insert into json_table02 select object_construct('Car_type',b.car_type, 'AvgCarIncome',b.AVERAGE_CAR_COST) from Avg_Car_Value_Table b;

select * from json_table02;

Create or replace file format JSON02 type ='JSON';

create or replace stage Json_unload02 file_format = JSON02;

copy into @json_unload02 from json_table02;


--Occupation avg Income--
create or replace procedure AvgOccupationIncome()
returns table()
language sql
as
declare
    res RESULTSET DEFAULT (create or replace table AvgOccupIncome as select row_number() over (order by OCCUPATION) as Index, OCCUPATION, round(avg(INCOME),2) as AvgIncome from CARINSURANCETABLE group by occupation);
begin
    return table(res);
end;

call AvgOccupationIncome();

select * from avgoccupincome;

--Json--
create or replace table json_table01(income variant); 

insert into json_table01 select object_construct('Occupation',a.occupation, 'AvgIncome',a.AvgIncome) from AVGOCCUPINCOME a;

select * from json_table01;

Create or replace file format JSON01 type ='JSON';

create or replace stage Json_unload01 file_format = json01;

copy into @json_unload01 from json_table01;

--Scheduling--
create or replace task task01
warehouse = COMPUTE_WH
schedule = '1 minute'
as
begin
call AvgCarValueProcedure(); 
call AvgOccupationIncome();
end;

--testing--
truncate table Avg_Car_Value_Table;
select * from AVG_CAR_VALUE_TABLE;
--testing--

show tasks

alter task task01 resume;

alter task task01 suspend;

--------------------------------------------------------Assignment 03--------------------------------------------------------------

create or replace table bluecollartable as select occupation,car_type, round(avg(clm_amt),2) as AvgClaimAmount from CARINSURANCETABLE where occupation = 'Blue Collar' and Car_use = 'Commercial' group by occupation, car_type having avg(clm_amt)<10000;

Create or replace materialized view InsuranceView as select * from bluecollartable;

select * from INSURANCEVIEW;


--------------------------------------------------------Assignment 04--------------------------------------------------------------
delete from carinsurancetable where id = '100130023';

create table cloning_check clone carinsurancetable at(offset=> -60*10);

select * from carinsurancetable limit 10;
select * from cloning_check limit 10;





insert into carinsurancetable values(100130023,0,'1955-05-02',	2,	13,	26763,	'Yes',	141019,	'No',	'F',	'Masters',	'Manager',	49,	'Private',	11500,	'SUV',	0,	0,	0,	11,'Highly Urban/ Urban');
