import getpass
import psycopg2

mypasswd = getpass.getpass()

connection = psycopg2.connect(database = 'data_science',
                              user = 'rducky',
                              host = 'srv-skyhelm-01',
                              password = mypasswd)

del mypasswd
