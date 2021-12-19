-- Total Cases,Total Deaths,Death Percentage
select sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, sum(new_deaths)/sum(new_cases)*100 as Death_percentage
from covid_deaths
order by 1,2;

-- Date wise breakup of Total Cases and Total Deaths and Death Percentage reported through out the World
-- Detailed report of above Query
select date,sum(new_cases) as Total_Cases,sum(new_deaths) as Total_Deaths,sum(new_deaths)/sum(new_cases)*100 as Death_percentage
from covid_deaths
group by date
order by date,death_percentage;

-- Highest Death Count in the World
select location, max(total_deaths) as Highest_death_count
from covid_deaths
where total_deaths > 50000
group by location
order by Highest_death_count desc;

-- Highest Infection rate among the countries
select location,population,max(total_cases) as Highest_cases_reported,max(total_cases/population)*100 as  Covid_Infected_Percentage
from covid_deaths
group by location,population
order by Covid_Infected_Percentage desc;

-- Highest Death Cases among countries
select location,population,date,max(total_deaths) as Highest_deaths_reported,max(total_deaths/population)*100 as  Covid_Death_Percentage
from covid_deaths
group by location,population,date
order by 4 desc;

-- Tests conducted
select d.location,d.date,v.new_tests
from covid_deaths d
join covid_vaccinations v 
on d.location = v.location 
and d.date = v.date
order by d.location,d.date;

-- Vaccination date wise in Canada
select d.location,d.date,d.population,v.new_vaccinations
from covid_deaths d
join covid_vaccinations v 
on d.location = v.location 
and d.date = v.date
where d.location='Canada'
order by d.location,d.date;

-- Cumulative Vaccination in Canada
select d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) as Cumulative_Vaccinations
from covid_deaths d
join covid_vaccinations v 
on d.location = v.location 
and d.date = v.date
where d.location='Canada'
order by d.location,d.date;

-- Vaccination Percentage
-- Use CTE 
With Vac_Rate(location,date,population,new_vaccinations,Cumulative_Vaccinations) as
(
select d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) as Cumulative_Vaccinations
from covid_deaths d
join covid_vaccinations v 
on d.location = v.location 
and d.date = v.date
)
Select *,(Cumulative_Vaccinations/Population)*100 as Vac_Percentage
from Vac_Rate;

-- Creating View
create view Covid_Infected_Percentage as
select location,date,population,max(total_cases) as Highest_cases_reported,max(total_cases/population)*100 as  Covid_Infected_Percentage
from covid_deaths
group by location,population;

create view Death_percentage as
select date,sum(new_cases),sum(new_deaths),(sum(new_deaths)/sum(new_cases))*100 as Death_percentage
from covid_deaths
group by date;

create view Canada_Cumulative_Vacs as 
select d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) as Cumulative_Vaccinations
from covid_deaths d
join covid_vaccinations v 
on d.location = v.location 
and d.date = v.date
where d.location='Canada';

