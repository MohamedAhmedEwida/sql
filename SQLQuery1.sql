select *
from PortfolioProject.dbo.CovidDeaths
order by  3,4
--select *
--from PortfolioProject.dbo.CovidVaccinations
--order by 2,3

--select data we that are going to stating with

select location,date,new_cases,total_cases,new_deaths,total_deaths,population
from PortfolioProject.dbo.CovidDeaths
where continent is not null 
--and location='Egypt'
order by 1,2

--select total_cases  vs  total_death 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject.dbo.CovidDeaths
WHERE location like '%EGYPT%'
order by  1,2

--Total Cases vs Population
select location,date,population,total_cases,(total_cases/population)* 100 as totalInfectionPercentage
from PortfolioProject.dbo.CovidDeaths
WHERE location like '%EGYPT%'
order by  1,2
-- Countries with Highest Infection Rate compared to Population
select location,population,MAX(total_cases)as highestInfectionCount,MAX((total_cases/population))*100 as highestInfectionPercentage
from PortfolioProject.dbo.CovidDeaths
WHERE continent='AFRICA'
GROUP BY location,population
order by  highestInfectionPercentage DESC  
-- Countries with Highest Death Count per Population

SELECT location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
group by location
order by  TotalDeathCount desc
-- BREAKING THINGS DOWN BY CONTINENT
SELECT location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.CovidDeaths
WHERE continent is  null
group by location
order by  TotalDeathCount desc
---- GLOBAL NUMBERS
select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_death,SUM(cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
from PortfolioProject.dbo.CovidDeaths
where continent is not null
GROUP BY date
order by 1,2

--Total Population vs Vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,
dea.date)  as RollingPeopleVaccinated,
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3

-- Using CTE to perform Calculation on Partition By in previous query
with popVSvac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,
dea.date)  as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select*,(RollingPeopleVaccinated/population)*100
 from popVSvac
 -- Using Temp Table to perform Calculation on Partition By in previous query
 drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

 insert into  #percentpopulationvaccinated
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,
dea.date)  as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 --order by 2,3
  select*,(RollingPeopleVaccinated/population)*100
 from #percentpopulationvaccinated
 -- Creating View to store data for later visualizations
create view #percentpopulationvaccinated as
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,
dea.date)  as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths  dea
join PortfolioProject..CovidVaccinations vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
--order by 2,3


select *
from #percentpopulationvaccinated