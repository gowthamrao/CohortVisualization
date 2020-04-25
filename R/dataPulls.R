getCohort <- function(connectionDetails,
                      cohortDatabaseSchema,
                      cohortDefinitionId,
                      cohortTable = 'cohort') {
  connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
  sql <-   "select *
            from @cohortDatabaseSchema.@cohortTable
            where cohort_definition_id = @cohortDefinitionId";

  sql <- SqlRender::render(
    sql = sql,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cohortDefinitionId = cohortDefinitionId,
    cohortTable = cohortTable
  )
  sql <-  SqlRender::translate(sql = sql,
                               targetDialect = connection@dbms)
  result <- DatabaseConnector::querySql(
    connection = connection,
    sql = sql,
    snakeCaseToCamelCase = TRUE
  )
  DatabaseConnector::disconnect(connection)
  return(result)
}

getPerson <- function(connectionDetails,
                      cdmDatabaseSchema,
                      cohortDatabaseSchema,
                      cohortDefinitionId,
                      cohortTable = 'cohort') {
  connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
  sql <-   "select p.person_id as subject_id,
            gender_concept_id, ethnicity_concept_id, race_concept_id,
            year_of_birth
            from @cdmDatabaseSchema.person p
            inner join
             (select distinct subject_id
              from @cohortDatabaseSchema.@cohortTable
              where cohort_definition_id = @cohortDefinitionId
              ) c
             on p.person_id = c.subject_id";

  sql <- SqlRender::render(
    sql = sql,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDefinitionId = cohortDefinitionId,
    cohortTable = cohortTable
  )
  sql <-  SqlRender::translate(sql = sql,
                               targetDialect = connection@dbms)
  result <- DatabaseConnector::querySql(
    connection = connection,
    sql = sql,
    snakeCaseToCamelCase = TRUE
  )
  DatabaseConnector::disconnect(connection)
  return(result)
}

getConditionOccurrence <- function(connectionDetails,
                                   cdmDatabaseSchema,
                                   cohortDatabaseSchema,
                                   cohortDefinitionId,
                                   cohortTable = 'cohort') {
  connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
  sql <-   "select cond.person_id,
                    condition_start_datetime,
                    condition_end_datetime,
                    condition_concept_id,
                    condition_type_concept_id,
                    condition_status_concept_id,
                    visit_occurrence_id,
                    visit_detail_id
            from @cdmDatabaseSchema.condition_occurrence cond
            inner join
             (select distinct subject_id
              from @cohortDatabaseSchema.@cohortTable
              where cohort_definition_id = @cohortDefinitionId
              ) c
             on cond.person_id = c.subject_id";

  sql <- SqlRender::render(
    sql = sql,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDefinitionId = cohortDefinitionId,
    cohortTable = cohortTable
  )
  sql <-  SqlRender::translate(sql = sql,
                               targetDialect = connection@dbms)
  result <- DatabaseConnector::querySql(
    connection = connection,
    sql = sql,
    snakeCaseToCamelCase = TRUE
  )
  DatabaseConnector::disconnect(connection)
  return(result)
}


getDrugExposure <- function(connectionDetails,
                            cdmDatabaseSchema,
                            cohortDatabaseSchema,
                            cohortDefinitionId,
                            cohortTable = 'cohort') {
  connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
  sql <-   "select d.person_id,
                    drug_exposure_start_datetime,
                    drug_exposure_end_datetime,
                    drug_concept_id,
                    drug_type_concept_id,
                    quantity,
                    days_supply,
                    visit_occurrence_id,
                    visit_detail_id
            from @cdmDatabaseSchema.condition_occurrence d
            inner join
             (select distinct subject_id
              from @cohortDatabaseSchema.@cohortTable
              where cohort_definition_id = @cohortDefinitionId
              ) c
             on cond.person_id = c.subject_id";

  sql <- SqlRender::render(
    sql = sql,
    cohortDatabaseSchema = cohortDatabaseSchema,
    cdmDatabaseSchema = cdmDatabaseSchema,
    cohortDefinitionId = cohortDefinitionId,
    cohortTable = cohortTable
  )
  sql <-  SqlRender::translate(sql = sql,
                               targetDialect = connection@dbms)
  result <- DatabaseConnector::querySql(
    connection = connection,
    sql = sql,
    snakeCaseToCamelCase = TRUE
  )
  DatabaseConnector::disconnect(connection)
  return(result)
}

downloadData <- function(connectionDetails,
                         cohortDatabaseSchema,
                         cohortDefinitionId,
                         cdmDatabaseSchema,
                         andromedaData = Andromeda::andromeda(),
                         saveAndromedLocation
) {
data <- andromedaData
data$cohort <- getCohort(connectionDetails = connectionDetails,
                         cohortDatabaseSchema = resultsDatabaseSchema,
                         cohortDefinitionId = cohortDefinitionId) %>%
  dplyr::tibble()
data$person <- getPerson(connectionDetails = connectionDetails,
                         cohortDatabaseSchema = resultsDatabaseSchema,
                         cdmDatabaseSchema = cdmDatabaseSchema,
                         cohortDefinitionId = cohortDefinitionId) %>%
  dplyr::tibble()
data$conditionOccurrence <- getConditionOccurrence(connectionDetails = connectionDetails,
                                                   cohortDatabaseSchema = resultsDatabaseSchema,
                                                   cdmDatabaseSchema = cdmDatabaseSchema,
                                                   cohortDefinitionId = cohortDefinitionId) %>%
  dplyr::tibble()
data$drugExposure <- getConditionOccurrence(connectionDetails = connectionDetails,
                                            cohortDatabaseSchema = resultsDatabaseSchema,
                                            cdmDatabaseSchema = cdmDatabaseSchema,
                                            cohortDefinitionId = cohortDefinitionId) %>%
  dplyr::tibble()

  if (!is.null(saveAndromedLocation)) {
    Andromeda::saveAndromeda(data, saveAndromedLocation)
  }
}


