library(magrittr)
filePathSourceFiles <- "d:/ignore"
source(paste0(filePathSourceFiles, "/ignoreThisFile.R"))
library(cohortVisualization)


cdmDataSources <- redShiftConnectionDetailsMetaData %>% dplyr::filter(sourceKey == 'OPTUM_EXTENDED_DOD')

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = cdmDataSources$dbms,
                                                                server = cdmDataSources$server,
                                                                port = cdmDataSources$port,
                                                                user = Sys.getenv("userSecureAWS"),
                                                                password = Sys.getenv("passwordSecureAWS")
)

cdmDatabaseSchema <- cdmDataSources$cdmDatabaseSchema
resultsDatabaseSchema <- 'ohdsi_results_charlie' # cdmDataSources$resultsDatabaseSchema
vocabDatabaseSchema <- cdmDataSources$vocabDatabaseSchema
sourceName <- cdmDataSources$sourceName
sourceDialect <- cdmDataSources$sourceDialect
cohortDefinitionId <- 442



cohortVisualization::downloadData(connectionDetails = connectionDetails,
             cohortDatabaseSchema = resultsDatabaseSchema,
             cdmDatabaseSchema = cdmDatabaseSchema,
             cohortDefinitionId = cohortDefinitionId,
             saveAndromedLocation = paste0(rstudioapi::getActiveProject(), "/data/data.zip")
)

