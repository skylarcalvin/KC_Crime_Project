import data_science_connect
from data_science_connect import connection

CREATE_SQL = 'DROP TABLE IF EXISTS KC_Crime_2018; '
CREATE_SQL += 'CREATE TABLE KC_Crime_2018 '
CREATE_SQL += '(report_no INT NOT NULL,'
CREATE_SQL += 'reported_date TIMESTAMP,'
CREATE_SQL += 'reported_time VARCHAR(50),'
CREATE_SQL += 'from_date TIMESTAMP,'
CREATE_SQL += 'from_time VARCHAR(50),'
CREATE_SQL += 'to_date TIMESTAMP,'
CREATE_SQL += 'to_time VARCHAR(50),'
CREATE_SQL += 'offense INT,'
CREATE_SQL += 'ibrs VARCHAR(50),'
CREATE_SQL += 'desription VARCHAR(150),'
CREATE_SQL += 'beat INT,'
CREATE_SQL += 'address VARCHAR(100),'
CREATE_SQL += 'city VARCHAR(100),'
CREATE_SQL += 'zip_code VARCHAR(5),'
CREATE_SQL += 'rep_dist VARCHAR(50),'
CREATE_SQL += 'area VARCHAR(50),'
CREATE_SQL += 'dvflag VARCHAR(50),'
CREATE_SQL += 'invl_no INT,'
CREATE_SQL += 'involvement VARCHAR(50),'
CREATE_SQL += 'race VARCHAR(1),'
CREATE_SQL += 'sex VARCHAR(1),'
CREATE_SQL += 'age INT,'
CREATE_SQL += 'firearm_used_flag VARCHAR(50),'
CREATE_SQL += 'longitude FLOAT(8),'
CREATE_SQL += 'latitude FLOAT(8),'
CREATE_SQL += 'PRIMARY KEY (report_no));'

with connection, connection.cursor() as cursor:
    cursor.execute(CREATE_SQL)
