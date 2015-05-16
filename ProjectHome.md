# Introduction #

We have lot of informations inside each monitoring server. It is possible to delete old history and do not take care of it or to analyze it. This project tries second issue. There can be very nice abnormalies or incidents, which are hidden if history is deleted and not analyzed.

Network technologies today can handle very high transfer speeds. It is still more difficult to do network flow analysis because of high speed and needs of more powerful hardware. Todays methods are based mainly to analyze data flows and patterns. It is quite impossible to find abnormalities on high speed link because small amount of change in flows can mean big excesses in incidents. Thesis project focus on multi criteria analysis of data to be able to predict incidents. From this reason, monitoring system seems to be good core for it.

# Background #

Today, this project is only in concept stage. It uses GNU Octave to analyze data and Zabbix API to get data from monitoring system. In future, after solving mathematical, statistical and neural network issues, it is needed to rewrite it as modular part of monitoring system, written in C or C++.

# What can we do now #

Today, we are able to:
  * Get data from Zabbix and save them as octave source files
  * Analyze, find correlations between data and save results
  * Graph interresting data
  * Work with analyzed data (gzip, gunzip, join, split, ...)
  * Analyzed data can be used as backup of Zabbix history

# What we want to do #

  * Neural analysis using Self-Organizing-Map
  * Interpret results back into zabbix (maps, graphs, ...)
  * Find interresting correlations and make a proof of concept

# Install #
