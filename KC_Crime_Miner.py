import os
import pandas as pd
import numpy as np
from sodapy import Socrata

socrata_domain = 'data.kcmo.org'
socrata_dataset_id = 'nyg5-tzkz'

socrata_token = os.environ.get('2BlqNquer3Zje80NhkrNCNJyU')

client = Socrata(socrata_domain, socrata_token)

results = client.get(socrata_dataset_id)
df = pd.DataFrame.from_dict(results)

df.to_csv('KC_Crime_2018_Sample.csv')
