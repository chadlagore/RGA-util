# `get_ga from the `RGA` package does not support querying multiple views. This function extends it
# to do so.
# 
# Typical usage:
#   get_ga_multiple(c(123125, 1231231), ...)
# 
# If length(profileIds) == 1, it defaults to `get_ga`.
# Requires: run authorize() before calling.


get_ga_multiple <- function(profileIds = getOption("rga.profileId"), start.date = "7daysAgo",
                            end.date = "yesterday", 
                            metrics = c("ga:users", "ga:sessions"," ga:pageviews"),
                            dimensions = NULL, sort = NULL, filters = NULL,
                            segment = NULL, samplingLevel = NULL, start.index = NULL,
                            max.results = NULL, include.empty.rows = NULL, fetch.by = NULL, token) {

  if (length(profileIds) == 1) {
    # Use default usage.
    return(get_ga(profileId = profileIds, start.date = start.date, end.date = end.date,
                  metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                  segment = segment, samplingLevel = samplingLevel, start.index = start.index,
                  max.results = max.results, include.empty.rows = include.empty.rows,
                  fetch.by = fetch.by, token=token))
  }

  token = authorize()
  print(paste("Processing", length(profileIds), "views"))

  results <- lapply(profileIds, function(x) {
    ans <- get_ga(profileId = x, start.date = start.date, end.date = end.date,
                  metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                  segment = segment, samplingLevel = samplingLevel, start.index = start.index,
                  max.results = max.results, include.empty.rows = include.empty.rows,
                  fetch.by = fetch.by, token)
    ans$profileId <- x
    return(ans)
  })

  results <- do.call(rbind, results)

  return(results)
}
