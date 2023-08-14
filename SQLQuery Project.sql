SELECT *
FROM PortfolioProject.DBO.CovidVaccinations;


SELECT *
FROM PortfolioProject.DBO.CovidDeaths;

--SELECT DATA WE ARE GOING TO USE
SELECT LOCATION, DATE,TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
FROM PortfolioProject.DBO.CovidDeaths;
--LOOKING AT THE TOTAL CASES VS TOTAL DEATHS
SELECT LOCATION,DATE,TOTAL_CASES,TOTAL_DEATHS,(TOTAL_DEATHS/TOTAL_CASES)*100 AS DEATHPERCENTAGE
FROM PortfolioProject.DBO.COVIDDEATHS
 WHERE LOCATION LIKE '%STATES';
 
 --SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID
 SELECT LOCATION, DATE, POPULATION,TOTAL_CASES, (TOTAL_CASES/POPULATION)*100 AS PERCENTPOPULATIONINFECTED
 FROM PortfolioProject.DBO.COVIDDEATHS
 WHERE LOCATION LIKE '%TAN%';

 --LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

 SELECT LOCATION, POPULATION, MAX(TOTAL_CASES) AS HIGHESTINFECTIONCOUNT , MAX((TOTAL_CASES/POPULATION))*100 AS PERCENTPOPULATIONINFECTED
 FROM PortfolioProject.DBO.COVIDDEATHS
 GROUP BY LOCATION, POPULATION
 ORDER BY PERCENTPOPULATIONINFECTED DESC;

 --SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

 SELECT LOCATION, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
 FROM PortfolioProject.DBO.COVIDDEATHS
 WHERE CONTINENT IS NOT NULL
 GROUP BY LOCATION
 ORDER BY TOTALDEATHCOUNT DESC;

 --LET'S BREAK THINGS DOWN BY CONTINENT
 SELECT CONTINENT, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
 FROM PortfolioProject.DBO.COVIDDEATHS
 WHERE CONTINENT IS NOT NULL
 GROUP BY CONTINENT
 ORDER BY TOTALDEATHCOUNT DESC;

 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
 FROM PortfolioProject.DBO.CovidDeaths dea
 JOIN PortfolioProject.dbo.covidvaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by dea.date desc

 --TEMP TABLE
 DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED
 
 Create table #PercentPOpulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population int,
 New_vaccinations int,
 RollingPeopleVaccinated int
 )

 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
 dea.Date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths dea
 Join PortfolioProject.dbo.CovidVaccinations vac
 On dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 
 Select *, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated

 SELECT *
 FROM #PERCENTPOPULATIONVACCINATED;
