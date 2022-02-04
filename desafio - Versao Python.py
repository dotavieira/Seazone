# -*- coding: utf-8 -*-
"""
Created on Tue Feb  1 02:21:44 2022

@author: VP
"""
import os
import pandas as pd
import datetime as dt

os.chdir('D:\Downloads\Victor\Processo Seletivo')

print(os.getcwd())

details = pd.read_csv("desafio_details.csv")
priceav = pd.read_csv("desafio_priceav.csv")

details_priceav = details.merge(priceav, on='airbnb_listing_id', how='left')


#####  Contando número de anúncios por bairro
Numero_por_suburbio = details.groupby(['suburb']).count()
print(Numero_por_suburbio['ad_name'])

#####  Contando número de anúncios por bairro
Media_por_suburbio = details_priceav.groupby(['suburb']).mean()
print(Media_por_suburbio['price_string'])

#####  Média de antecedência
Media_antecedencia = details_priceav[(details_priceav.occupied == 1)]

Media_antecedencia['Antecedencia'] = Media_antecedencia['date'].apply(lambda x: 
                                    dt.datetime.strptime(x,'%Y-%m-%d'))
Media_antecedencia['Antecedencia'] = Media_antecedencia['booked_on'].apply(lambda x: 
                                    dt.datetime.strptime(x,'%Y-%m-%d'))

