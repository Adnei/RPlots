# @TODO REFACTOR
get_api_calls <- function(os_list, operation_list, conn_list, params_list){
  string_query <- build_api_query()
  os_api_calls <- list()
  idx <- 1
  for (os in os_list){
    for (operation in operation_list){
      api_calls <- dbSendQuery(conn_list[[idx]], string_query)
      dbBind(api_calls, param=list(
        start=c(params_list[[os]][[operation]]$start[2]), #FIXED SESSION 2
        end=c(params_list[[os]][[operation]]$end[2])#FIXED SESSION 2
      ))
      fetch_api_calls <- dbFetch(api_calls)
      # dbDisconnect(conn)
      dbClearResult(api_calls)
      os_api_calls[[os]][[operation]] <- fetch_api_calls
    }
    idx <- idx + 1
  }

  os_api_calls

}


# @TODO REFACTOR #SESSION FIXED 2
build_api_query <- function(){
  string_query <- 'select service, group_concat(total) as num_calls
                                        from (select service, count(id) as total from apidata
                                        where
                                        time >= :start
                                        and time <= :end
                                        and session_id = 2
                                        group by service, session_id)
                              group by service;'
}
