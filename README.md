# deforestation-exploration
I'm a data analyst for ForestQuery, a non-profit organization, on a mission to reduce deforestation around the world and which raises awareness about this important environmental topic.
I'm looking to understand which countries and regions around the world seem to have forests that have been shrinking in size, and also which countries and regions have the most significant forest area, both in terms of amount and percent of total area. The hope is that these finidngs can help inform intiatives, communications, and personnel allocation to achieve the largest impact with the precious few resources that the organization has at its disposal.
I've been able to find tables of data online dealing with forestation as well as total land area and region groupings, and i've brought these tables together into a database that i'd liek to  query to answer some of the most important questions in preparation for a meeting with the ForestQuery executuve team coming up in a few days. Ahead of the meeting, i'd like to prepare and disseminate a report for the leadership team that uses complete sentences to help them understand the global deforestation overview between 1990 and 2016.
Steps:
1. Create a view called 'forestation' by joining all three tables - forest_area,land_area and regions in the workspace
2. The forest_area and land_area tables join on both country_code and year
3. The regions table joins these based on only country_code
4. In the 'forestation' view, include the following: all the columns of the origin tables, a new column that provides the percent of the lan area that is designated a forest
5. forest_area_sqkm in the forest_area_table and the land_area_sqmi in the land_area table are in different units(square kilometers and square miles), so i adjusted the calculations as 1 sq mi - 2.59 sq km
I have attached the file which is created for this work 
[Copy of Deforestation Exploration Solution Template.pdf](https://github.com/SwethaVasudev/deforestation-exploration/files/9578677/Copy.of.Deforestation.Exploration.Solution.Template.pdf)
