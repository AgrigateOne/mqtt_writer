# MQTT Writer

This app runs as a service listening for data from Gossamer PLCs - sent from MesServer and writes data from the messages to a database table.

## Database table

The structure of the table:

```sql
-- POSTGRESQL version of table:

CREATE TABLE mqtt_msg (
	id int4 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  topic character varying(255),
  qos integer,
  payload text,
  mesmodule text,
  plc_module text,
  packline integer,
  machineid integer,
  packcount integer,
  labelprintqty integer,
  printcommand integer,
  accumulator_70_perc integer,
  accumulator_perc integer,
  alarm_active integer,
  alarm_code integer,
  totalcount integer,
  producing integer,
  noproduct integer,
  nocartons integer,
  buildback integer,
  stopped integer,
  fault integer,
  total_spare_1 integer,
  total_spare_2 integer,
  total_spare_3 integer,
  activecounter integer,
  speedperhour integer,
  created_at timestamptz,
	CONSTRAINT mqtt_msg_pkey PRIMARY KEY (id)
);

-- MSSql Server version of the table:

CREATE TABLE dbo.mqtt_msg (
	id int IDENTITY(1,1) NOT NULL,
	topic nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	qos int NULL,
	payload nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mesmodule nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	plc_module nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	packline int NULL,
	machineid int NULL,
	packcount int NULL,
	labelprintqty int NULL,
	printcommand int NULL,
	accumulator_70_perc int NULL,
	accumulator_perc int NULL,
	alarm_active int NULL,
	alarm_code int NULL,
	totalcount int NULL,
	producing int NULL,
	noproduct int NULL,
	nocartons int NULL,
	buildback int NULL,
	stopped int NULL,
	fault int NULL,
	total_spare_1 int NULL,
	total_spare_2 int NULL,
	total_spare_3 int NULL,
	activecounter int NULL,
	speedperhour int NULL,
	created_at datetime NOT NULL,
	CONSTRAINT PK_mqtt_msg PRIMARY KEY (id)
);
```
## Config

Config is written in the form of environement variables in the `.env.local` file.

For a postgresql connection, add the following line:
```
DATABASE_URL=postgres://postgres:<user>@<host>/<db_name>
```

For an MSSQL connection, add the following lines instead:
```
DATABASE_URL=tinytds
MSSQL_HOST=127.0.0.1
MSSQL_PORT=1433
MSSQL_DB=<dbname>
MSSQL_USER=<user>
MSSQL_PW=<password>
```

## Prerequisites

### Mosquitto

```sh
sudo apt install mosquitto
sudo systemctl status mosquitto
```

### FreeTDS

Only do this if connecting to MSSQL.
```sh
sudo apt install freetds-dev
```