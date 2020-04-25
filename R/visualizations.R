







#
#
# extractDistinctValue <- function(df, field) {
#   df %>% dplyr::select(field) %>% dplyr::collect() %>% unique() %>% dplyr::pull()
# }
# conceptIds <- c(extractDistinctValue(data$personData, genderConceptId),
#                 extractDistinctValue(data$personData, raceConceptId),
#                 extractDistinctValue(data$personData, ethnicityConceptId)
# ) %>%  unique()
#
# conceptIds <- ROhdsiWebApi::getConcepts(conceptIds = conceptIds,
#                           baseUrl = Sys.getenv("baseUrl"))
#
#
# cohortDatadata <- cohortData %>%
#         dplyr::select(subjectId, cohortStartDate, cohortEndDate) %>%
#         dplyr::left_join(personData) %>%
#         dplyr::mutate(age = lubridate::year(cohortStartDate) - yearOfBirth) %>%
#         dplyr::left_join(conceptIds %>%
#                            dplyr::select(conceptId, conceptName) %>%
#                            dplyr::rename(genderConceptName = conceptName),
#                          by = c('genderConceptId' = 'conceptId')) %>%
#         dplyr::select(subjectId,
#                       cohortStartDate,
#                       cohortEndDate,
#                       yearOfBirth,
#                       age,
#                       genderConceptName)
#
# plotData <- data %>%
#             dplyr::mutate(age = (floor(age/10)*10)+10,
#                           year = lubridate::year(cohortStartDate)
#                           ) %>%
#             dplyr::group_by(age, year) %>%
#             dplyr::summarise(n = n()) %>%
#             dplyr::select(age, year, n) %>%
#             unique()
#
#
# ggplot2::ggplot(plotData, ggplot2::aes(x=year, y=age, fill= n)) +
#   ggplot2::geom_tile() +
#   viridis::scale_fill_viridis(discrete = FALSE)
#
