#selecting the columns that i am going to use in this analysis
SET SQL_SAFE_UPDATES = 0;
update
coviddeaths
set 
total_cases= if(total_cases='', null, total_cases),
total_deaths= if(total_deaths='', null, total_deaths);

update
covidvaccinations
set 
#total_vaccinations= if(total_vaccinations='', null, total_vaccinations),
#people_vaccinated= if(people_vaccinated='', null, people_vaccinated),
#people_fully_vaccinated= if(people_fully_vaccinated='', null, people_fully_vaccinated),
new_vaccinations= if(new_vaccinations='', null, new_vaccinations);
#new_vaccinations_smoothed= if(new_vaccinations_smoothed='', null, new_vaccinations_smoothed),
#new_vaccinations= if(new_vaccinations='', null, new_vaccinations),
#new_vaccinations= if(new_vaccinations='', null, new_vaccinations),
#new_vaccinations= if(new_vaccinations='', null, new_vaccinations),





select location,date,total_cases,new_cases,total_deaths,population
from project2.coviddeaths
order by 1,2

#looking at total cases vs total deaths
#looking at the affects on my country 

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from project2.coviddeaths
where location like '%india%'
order by 1,2

#looking at total cases vs population
#percentage of population got affected


select location,date,population,total_cases,(total_cases/population)*100 as affected_population
from project2.coviddeaths
#where location like '%india%'
order by 1,2
#looking at countries with highest infection rate

select location,population,max(total_cases) as highest_infectioncount,max(total_cases/population)*100 
as affected_population
from project2.coviddeaths
group by location,population
#where location like '%india%'
order by affected_population desc


#the countries with highest death counts

select location,max(cast(total_deaths as UNSIGNED)) as death_count
from project2.coviddeaths
where continent is not null
group by location
order by death_count desc

#from the continent view death conunts

select continent,max(cast(total_deaths as UNSIGNED)) as death_count
from project2.coviddeaths
where continent is not null
group by continent
order by death_count desc

#Global numbers
select  sum(new_cases)as total_cases,sum(new_Deaths) as total_deaths,
sum(cast(new_deaths as unsigned))/sum(total_cases)*100 as deathpercentage
from project2.coviddeaths
where continent is not null
order by 1,2

#joining both tables
select* 
from project2.coviddeaths dea
join project2.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

#looking at the total population vs vaccination
#useing cte

with pepvsvac (continent,location,date,population,new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated,
from project2.coviddeaths dea
join project2.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
#order by 2,3
)
select * ,( rollingpeoplevaccinated/population)*100
from pepvsvac


#temp table
drop table if exists percentpopulationvaccinated
create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new vacctinations numeric,
rollingpeoplevaccinated
)

insert into
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated,
from project2.coviddeaths dea
join project2.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
#where dea.continent is not null
#order by 2,3
)
select * ,( rollingpeoplevaccinated/population)*100
from rollingpeoplevaccinated
