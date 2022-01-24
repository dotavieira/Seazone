library(tidyverse)
library(hms)
library(plotly)

#Ageitando o Working Directory
setwd("D:/Downloads/Victor/Processo Seletivo")

## Lendo os dados
details = read.csv2("desafio_details.csv", sep = ',', encoding = 'UTF-8')
priceav = read.csv2("desafio_priceav.csv", sep = ',', encoding = 'UTF-8')

## Criando uma tabela mais completa com todos os dados, para efeito de testes
details_priceav = details %>% inner_join( priceav, by=( c("airbnb_listing_id" = "airbnb_listing_id") ) )

#################################  1
## Número de ID's para cada subúrbio, listando em ordem crescente
Numero_de_airbnb_suburbio = details %>% 
                              group_by(suburb) %>%
                              summarise(`Número de AirBnB's` = n()) %>%
                              arrange(`Número de AirBnB's`) %>%
                              rename(Bairro = suburb)

graph_1 <- plot_ly(Numero_de_airbnb_suburbio, labels = ~Bairro, values = ~`Número de AirBnB's`, marker = list(colors = c('#ff5733', '#ffbd33','#dbff33', '#75ff33', '#33ffbd')), type = 'pie') %>%
            layout(title = "Número de AirBnB's por região")
graph_1

#################################  2
## Média de valor por subúrbio
Media_valor_suburbio = details_priceav %>% 
                        group_by(suburb) %>% 
                        filter(occupied > 0) %>%
                        summarise(Ocorrencias = n(),Total = sum(as.numeric(price_string))) %>% 
                        mutate(Media = Total/Ocorrencias) %>%
                        rename(Bairro = suburb) %>%
                        arrange(Media)

graph_2 <- plot_ly(Media_valor_suburbio, x = ~Bairro, y = ~Media, type = 'bar', color = ~Bairro,
                   colors = c(Ingleses = '#33ffbd', Canasvieiras = '#75ff33', Jurerê = '#dbff33', `Lagoa da Conceição` = '#ffbd33', Centro = '#ff5733')) %>%
            layout(title = "Valor médio de anúncio por região")
graph_2


#################################  4
### DIAS GERAIS
## Criando coluna para mostrar a antecedência de agendamento
Antecedencia_agendamento = priceav %>%
                            filter(occupied > 0) %>% 
                            mutate(`Antecedência` = as.Date(date, "%Y-%m-%d") - as.Date(booked_on, "%Y-%m-%d")) %>%
                            mutate(`Dia semana da reserva` = weekdays(as.Date(date, "%Y-%m-%d")))

## Média de antecedência de agendamento
`Média antecedência de agendamento` = sum(Antecedencia_agendamento$Antecedência)/nrow(Antecedencia_agendamento)

### FIM DE SEMANA
## Criando coluna para mostrar a antecedência de agendamento do fim de semana
Antecedencia_agendamento_fds = Antecedencia_agendamento %>%
                                filter(`Dia semana da reserva` == 'sábado' | `Dia semana da reserva` == 'domingo')

## Média de antecedência de agendamento do fim de semana
`Média antecedência de agendamento FDS` = sum(Antecedencia_agendamento_fds$Antecedência)/nrow(Antecedencia_agendamento_fds)





