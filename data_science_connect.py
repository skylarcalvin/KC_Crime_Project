#
# Written by Skylar Calvin
# year 2018
# Connectes to postgres database on my AWS instance.
#

import getpass
import psycopg2

mypasswd = getpass.getpass()

connection = psycopg2.connect(database = 'data_science',
                              user = 'rducky',
                              host = 'datascience-test.ce7gijyt5i37.us-east-1.rds.amazonaws.com',
                              password = mypasswd)

del mypasswd
