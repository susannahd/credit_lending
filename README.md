# credit_lending
Code and files related to the expansion of a credit lending program for formerly incarcerated people

About
This tool was developed to help prioritize states/counties for the expansion of a credit lending program for formerly incarcerated individuals. It incorporates state-level data on prison populations (from the Sentencing Project), state- and county-level unemployment data (from the Bureau of Labor Statistics), state-level data on prison and jail releases (from the Prison Policy Initiative) and state-, county- and city-level data on partners who assist formerly incarcerated individuals (gathered and geo-tagged by CIMA).

There are several data integrity issues when it comes to finding data on formerly incarcerated people that should be acknowledged: 

**1. Data is sometimes unavailable**: Often, there's not data on certain metrics of interest, for example, formerly incarcerated individuals living in the United States. We have to use estimates from academic studies in these cases. 
**2. Data is often unavailable at a granular level**: Our country's criminal justice system is complex; each state/county/jurisdiction/city tracks data on jails and prisons differently (or sometimes not at all), making it difficult to make apples to apples comparisons in many cases.
**3. Data is often unavailable in a recent time period**: Fortunately, there is some robust data provided by the United States census, but as of 10-17-2021, data is only available through 2010. Some of the data used in this dashboard is more recent (2013 data on jails, 2016 data on prisons, etc.), but it's important to acknowledge that data may come from different time periods and not reflect current reality. 

This dashboard does:

Output a map (darker circles indicate partners in locations with higher prison populations) of partners supporting formerly incarcerated individuals
Output a table with the compiled data for a selected state, including prison population, prison and jail releases, unemployment rate, partner, partner website, and service category. 
Allow users to download a csv of the data within the table to help guide decisions on local investigations and on-the-ground reporting

This dashboard doesn't:

Account for funding opportunities or qualitative data on the quality of services for formerly incarcerated individuals

Dashboard Functionality
Update Dashboard
You must click 'Update Dashboard' before the dashboard will render a map and a table.

Feedback
If you have any questions or feedback, please contact me.
