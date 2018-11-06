import pandas as pd
from sodapy import Socrata

client = Socrata('data.kcmo.org', '2BlqNquer3Zje80NhkrNCNJyU')

results = client.get('nyg5-tzkz')
df = pd.DataFrame.from_dict(results)

print(len(df))
