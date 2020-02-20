source("get_data.R")

centos_conn = dbConnect(sqlite, dbname=centos_file)

choosen_exec <- 2
db_info_create <- data.frame(column='m_total', label='total', table='meteringdata', session_id=choosen_exec)
centos_create_params <- list(
  time = c(centos_params$start[choosen_exec]:centos_params$end[choosen_exec])
)
interval <- FALSE
centos_create_traffic <- get_traffic(centos_conn, centos_create_params, db_info_create, interval)






pdf("timelinePlot.pdf")
y <- c(centos_create_traffic$total)/1000000
x <- c(1:length(y))
plot(x,y, lwd=1, type = 'n', xlab='Tempo (s)', ylab = 'Volume (MB)', cex.lab=1.2, font.lab=2, xaxt="n")


create_start=1
create_end=length(centos_create_traffic$total) #length -1 (provavelmente)
lines(x[1:create_end],y[1:create_end] , col='#000080', lwd=3, type='l')
axis(1,c(create_start,create_end), col='#000080', lwd=2, padj = 1, cex.axis=0.9)

dbDisconnect(centos_conn)
