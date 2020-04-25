library(magrittr)

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = Sys.getenv("dbms"),
                                                                server = Sys.getenv("server"),
                                                                port = Sys.getenv("port")
)
cdmDataSources <- ROhdsiWebApi::getCdmSources(baseUrl = Sys.getenv("baseUrl")) %>%
  dplyr::filter(sourceKey == 'OPTUM_EXTENDED_DOD')
cdmDatabaseSchema <- cdmDataSources$cdmDatabaseSchema
resultsDatabaseSchema <- cdmDataSources$resultsDatabaseSchema
vocabDatabaseSchema <- cdmDataSources$vocabDatabaseSchema
sourceName <- cdmDataSources$sourceName
sourceDialect <- cdmDataSources$sourceDialect
cohortDefinitionId <- 15908
