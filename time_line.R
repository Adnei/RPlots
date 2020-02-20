time_line.plot <- function(conn_list, params_list){


  query_info <- data.frame(column='m_total as total', table='meteringdata', session_id=2)

  custom_params_arr <- list(
    centos = list(
      title = 'Linha do tempo: Centos7 (1.3 GB)',
      pdf = 'centosTimeLine.pdf',
      query_info = query_info
    ),
    windows = list(
      title = 'Linha do tempo: Windows Server 2012 R2',
      pdf = 'windowsTimeLine.pdf',
      query_info = query_info
    ),
    mint = list(
      title = 'Linha do tempo: GNU/Linux Mint 19.1',
      pdf = 'mintTimeLine.pdf',
      query_info = query_info
    ),
    centosLight = list(
      title = 'Linha do tempo: Centos7 (898 MB)',
      pdf = 'centosLightTimeLine.pdf',
      query_info = query_info
    ),
    cirros = list(
      title = 'Linha do tempo: CirrOS 0.4.0',
      pdf = 'cirrosTimeLine.pdf',
      query_info = query_info
    ),
    debian = list(
      title = 'Linha do tempo: GNU/Linux Debian 9.9.4 (OpenStack)',
      pdf = 'debianTimeLine.pdf',
      query_info = query_info
    ),
    fedora = list(
      title = 'Linha do tempo: Fedora Cloud 30-1.2',
      pdf = 'fedoraTimeLine.pdf',
      query_info = query_info
    ),
    ubuntu = list(
      title = 'Linha do tempo: GNU/Linux Ubuntu Server 18.04 LTS (Bionic Beaver)',
      pdf = 'ubuntuTimeLine.pdf',
      query_info = query_info
    )
  )
  idx <- 1

  for(custom_params in custom_params_arr){
    timeline_plot(
      conn_list[[idx]],
      params_list[[os_list[idx]]],
      custom_params$query_info,
      pdf_file=custom_params$pdf,
      custom_params$title
    )
    idx <- idx + 1
  }
}
