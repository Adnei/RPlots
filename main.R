source('params.R')
source('plots.R')
source('get_data.R')
source('time_line.R')
source('traffic.R')
source('api_calls.R')
library(RSQLite)
sqlite <- dbDriver('SQLite')

conn_list <- get_conn_list()

# time_line.plot(conn_list, params_list)

operation_list <- c('create', 'suspend', 'resume', 'stop', 'shelve')
os_sizes <- c(1300, 6500, 1800, 898, 15, 2000,319, 329)

os_traffic.total <- traffic.total(os_list, operation_list, conn_list, params_list)
os_traffic.by_service <- traffic.by_service(os_list, operation_list, conn_list, params_list)

idx <- 1
os_diff_list <- list()
for(os in os_list) {
  for(op in c('create', 'shelve')){
    os_diff_list[[os]][[op]] <- (os_traffic.total[[os]][[op]][2] - os_sizes[idx])
  }
  idx <- idx + 1
}

plot_diff(os_sizes, os_list, os_diff_list)

# operation took_seconds
# idx <- 0
# for(os in os_list) {
#   cat('\n', os, '\n')
#   for(op in operation_list){
#     idx <- idx + 1
#     if(idx == length(operation_list)){
#       cat(params_list[[os]][[op]]$took_secs[2], '')
#     } else {
#       cat(params_list[[os]][[op]]$took_secs[2], ' & ')
#     }
#   }
#   idx <- 0
# }


# @TODO REFACTOR
# @TODO get_api_calls needs several refactors. U Should consider redo it from scratch
os_api_calls <- get_api_calls(os_list, operation_list, conn_list, params_list)

# TOTAL --> sum(as.integer(os_api_calls$centos$create$num_calls))

for (conn in conn_list){
  dbDisconnect(conn)
# conn_list[[idx]]
}
