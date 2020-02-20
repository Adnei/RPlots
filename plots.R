#
#  TODO
#    Must provide support for query_info$session_id_list. Multiple executions.
#    Maybe an average between the executions...
#
timeline_plot <- function(conn, params, query_info, pdf_file, title){
  if(missing(pdf_file)){
      pdf_file <- 'timelinePlot.pdf'
  }
  if(missing(title)){
      title <- ''
  }
  op_arr <- c('create', 'suspend', 'resume', 'stop', 'shelve')
  label_pos <- c(0,1,2,3,0)
  col_arr <- c('#000080', '#800000', '#267326', '#e68a00', '#cc0000')
  operation_traffic_list <- load_traffic_list(conn, params, query_info, op_arr)

  axis_y <- c()
  for(op in op_arr){
    axis_y <- append(axis_y, operation_traffic_list[[op]]) #to MB)
  }
  axis_x <- c(1:length(axis_y))

  # axis_y/1000000 #to MB
  pdf(pdf_file)
  par(mar = c(6, 6, 3.5, 3.5), mgp = c(5, 1, 0))
  plot(
    axis_x,axis_y,
    lwd=1,
    type = 'n',
    xlab='Tempo (s)',
    ylab = 'Volume de Tráfego (MB)',
    cex.lab=1.2,
    font.lab=2,
    xaxt='n',
    main=title
  )

  idx <- 1
  axis_start <- 0
  axis_end <- 0
  for(op in op_arr){
    axis_start <- axis_end + 1
    axis_end <- axis_start + length(operation_traffic_list[[op]]) -1

    lines(axis_x[axis_start:axis_end],axis_y[axis_start:axis_end] , col=col_arr[idx], lwd=3, type='l')
    axis(1,c(axis_start,axis_end), col=col_arr[idx], lwd=2, padj = label_pos[idx], cex.axis=0.9)

    # if(title == 'Linha do tempo: GNU/Linux Debian 9.9.4 (OpenStack)'){
    #   print(op)
    #   cat("Eixo X = ",axis_x[axis_start:axis_end], "\n")
    #   cat("Eixo Y = ",axis_y[axis_start:axis_end], "\n")
    #   cat("MAX Y --> ", max(axis_y[axis_start:axis_end]), "\n")
    #   cat("\n")
    #
    #   if(op == 'create' || op == 'shelve'){
    #     cat("which -> ", which(axis_y[axis_start:axis_end] > 100), "\n" )
    #     cat("peak -> ", sum(axis_y[axis_start:axis_end][which(axis_y[axis_start:axis_end] > 40)]), "\n")
    #     cat("valores em X -> ", axis_x[axis_start:axis_end][which(axis_y[axis_start:axis_end] > 40)], "\n")
    #   }
    # }



    idx <- idx +1
  }

  legend('top',
       legend = c('Operação CREATE()', 'Operação SUSPEND()','Operação RESUME()','Operação STOP()','Operação SHELVE()'),
       col = col_arr,
       lty=1, lwd=2, cex=0.8, text.font=2, box.lty=0, bg="transparent"
)

}

#
# @IMPORTANT!!! OP_ARR MUST BE THE SAME SIZE AS PARAMS
#
load_traffic_list <- function(conn, params, query_info, op_arr){
  idx <- 1
  operation_traffic_list <- list()

  for(operation in params){
    operation_traffic <- get_traffic(
      conn,
      list(
        time = c(operation$start[query_info$session_id]:operation$end[query_info$session_id])
      ),
      query_info,
      interval=FALSE
    )
    operation_traffic_list[[op_arr[idx]]] <- operation_traffic$total
    idx <- idx + 1
  }
  operation_traffic_list
}


#FIXED FOR CREATE
plot_diff <- function(os_sizes, os_list, os_diff_list){
  traffic_diff <- c()
  for(os in os_list){
    traffic_diff <- append(traffic_diff, os_diff_list[[os]][['create']])
  }

  pdf('trafficDiff.pdf')
  plot(os_sizes, traffic_diff, pch=20, xlab="Tamanho da imagem (MB)", ylab="SHELVE - Imagem (MB)")
  text(os_sizes, traffic_diff, labels=os_list, cex=0.9, pos=c(1,1,3,4,3))
  # plot(traffic_diff, os_sizes, pch=20, xlab="Tamanho da imagem (MB)", ylab="SHELVE - Imagem (MB)")
  # text(traffic_diff, os_sizes, labels=os_list, cex=0.9, pos=c(1,1,3,4,3))
}
