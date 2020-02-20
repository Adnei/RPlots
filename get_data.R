#Doesn't work for API calls.
get_total_traffic <- function(conn, params, query_info, interval){
  if(missing(interval)){
      interval <- TRUE
  }
  fetch_total <- get_traffic(conn, params, query_info, interval)
  data.frame(
    'create'=fetch_total[c(1:5),1], #to MB
    'suspend'=fetch_total[c(6:10),1],
    'resume'=fetch_total[c(11:15),1],
    'stop'=fetch_total[c(16:20),1],
    'shelve'=fetch_total[c(21:25),1]
  )
}

get_traffic <- function(conn, params, query_info, interval){
  if(missing(interval)){
      interval <- TRUE
  }
  string_query <- build_query(query_info, interval)
  total_traffic <- dbSendQuery(conn, string_query)
  dbBind(total_traffic, param=params)
  fetch_total <- dbFetch(total_traffic)
  # dbDisconnect(conn)
  dbClearResult(total_traffic)
  fetch_total/1000000 #returns in MB
}

#I rlly didn't mean to do this :/ (I'm so sorry)
#PLEASE GET RID OF THIS CODE. U TWAT!!! (it hurts my eyes bruh ;-;)
#paste is not good for queries ;-;
# @DEPRECATED --> query_info$label is now deprecated
build_query <- function(query_info, interval){
  conditional_statement <- 'where time = :time and session_id ='
  session_id <- ':id'
  from_statement <- ', session_id from'
  if(missing(interval) || interval == TRUE){
      interval <- TRUE
      conditional_statement <- 'where time >= :start and time <= :end and session_id ='
  }
  if("session_id" %in% colnames(query_info)){
    session_id <- query_info$session_id
    from_statement <- ' from'
  }

  string_query <- 'select'
  string_query <- paste(string_query, query_info$column, sep=' ')
  # string_query <- paste(string_query,'as', sep=' ')
  # string_query <- paste(string_query,query_info$label, sep=' ')
  string_query <- paste(string_query,from_statement, sep='')
  string_query <- paste(string_query, query_info$table, sep=' ')
  string_query <- paste(string_query,conditional_statement,sep=' ')
  string_query <- paste(string_query,session_id,sep=' ')
  string_query
}

# get_api_calls <- function(conn, params, query_info, interval){
#
# }
