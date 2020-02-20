traffic.total <- function(os_list, operation_list, conn_list, params_list){
  #get_data.
  query_info_total_traffic <- data.frame(column='sum(m_total) as total', table='meteringdata')
  idx <- 1
  os_traffic.total <- list()
  for(os in os_list){
    start_times <- c()
    end_times <- c()
    for(operation in operation_list){
      start_times <- append(start_times, params_list[[os]][[operation]]$start)
      end_times <- append(end_times, params_list[[os]][[operation]]$end)
    }

    os_traffic.total[[os]] <- get_total_traffic(
      conn_list[[idx]],
      list(
        start = start_times,
        end = end_times,
        id = rep(c(1:5),5)
      ),
      query_info_total_traffic,
      interval=TRUE
    )
    idx <- idx +1
  }
  os_traffic.total
}

db_info_total <- data.frame(column='sum(m_total) as total', table='meteringdata')
db_info_glance <- data.frame(column='sum(m_glance) as glance', table='meteringdata')
db_info_nova <- data.frame(column='sum(m_nova) as nova', table='meteringdata')
db_info_keystone <- data.frame(column='sum(m_keystone) as keystone', table='meteringdata')
db_info_neutron <- data.frame(column='sum(m_neutron) as neutron', table='meteringdata')
db_info_etc <- data.frame(column='sum(m_etc) as etc', table='meteringdata')


traffic.by_service <- function(os_list, operation_list, conn_list, params_list){
  #get_data.
  query_info_service_traffic <- data.frame(
      column=' sum(m_glance) as glance, sum(m_nova) as nova, sum(m_keystone) as keystone, sum(m_neutron) as neutron, sum(m_etc) as etc, sum(m_total) as total',
      table='meteringdata',
      session_id=2
  )

  idx <- 1
  os_traffic.by_service <- list()
  # get_traffic <- function(conn, params, query_info, interval){
  for(os in os_list){
    for(operation in operation_list){
      os_traffic.by_service[[os]][[operation]] <- get_traffic(
        conn_list[[idx]],
        list(start=params_list[[os]][[operation]]$start, end=params_list[[os]][[operation]]$end),
        query_info_service_traffic,
        interval=TRUE
      )
    }
    idx <- idx + 1
  }
  os_traffic.by_service
}
