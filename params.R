# common_root <- '/home/ripple/experiments/results_v2/'
common_root <- '/home/ripple/experiments/results_v2/'
os_list <- c('centos', 'windows', 'mint', 'centosLight', 'cirros', 'debian','fedora', 'ubuntu')

centos_file <- paste(common_root, 'centos7_1_3G/centos7_1_3G.db', sep='')
windows_file <- paste(common_root, 'windows_6G/windows_6G.db', sep='')
mint_file <- paste(common_root, 'mint_1_8G/mint_v2.db', sep='')
centosLight_file <- paste(common_root, 'centos_light_898MB/centos_light.db', sep='')
cirros_file <- paste(common_root, 'cirros/cirros.db', sep='')
debian_file <- paste(common_root, 'debian_2G/debian_v2.db', sep='')
fedora_file <- paste(common_root, 'fedora/fedora_v2.db', sep='')
ubuntu_file <- paste(common_root, 'ubuntu/ubuntu.db', sep='')

reports <- list (
  centos_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/centos.csv', sep=''), sep=","),
  windows_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/windows.csv', sep=''), sep=","),
  mint_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/mint.csv', sep=''), sep=","),
  centosLight_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/centosLight.csv', sep=''), sep=","),
  cirros_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/cirros.csv', sep=''), sep=","),
  debian_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/debian.csv', sep=''), sep=","),
  fedora_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/fedora.csv', sep=''), sep=","),
  ubuntu_report = read.table(file=paste(common_root, 'Exp_Plots/Report_eng/csv/ubuntu.csv', sep=''), sep=",")
)
db_info_total <- data.frame(column='sum(m_total) as total', table='meteringdata')
db_info_glance <- data.frame(column='sum(m_glance) as glance', table='meteringdata')
db_info_nova <- data.frame(column='sum(m_nova) as nova', table='meteringdata')
db_info_keystone <- data.frame(column='sum(m_keystone) as keystone', table='meteringdata')
db_info_neutron <- data.frame(column='sum(m_neutron) as neutron', table='meteringdata')
db_info_etc <- data.frame(column='sum(m_etc) as etc', table='meteringdata')

#  TODO
#    db_info_api

idx <- 1
params_list <- list()
for(os_report in reports){
  params_list[[idx]] <- list(
    create = list(
      start = c(
        subset(os_report, V2 == 'create')$V4
      ),
      end = c(
        subset(os_report, V2 == 'create')$V5
      ),
      took_secs = c(
        subset(os_report, V2 == 'create')$V8
      )
    ),
    suspend = list(
      start = c(
        subset(os_report, V2 == 'suspend')$V4
      ),
      end = c(
        subset(os_report, V2 == 'suspend')$V5
      ),
      took_secs = c(
        subset(os_report, V2 == 'suspend')$V8
      )
    ),
    resume = list(
      start = c(
        subset(os_report, V2 == 'resume')$V4
      ),
      end = c(
        subset(os_report, V2 == 'resume')$V5
      ),
      took_secs = c(
        subset(os_report, V2 == 'resume')$V8
      )
    ),
    stop = list(
      start = c(
        subset(os_report, V2 == 'stop')$V4
      ),
      end = c(
        subset(os_report, V2 == 'stop')$V5
      ),
      took_secs = c(
        subset(os_report, V2 == 'stop')$V8
      )
    ),
    shelve = list(
      start = c(
        subset(os_report, V2 == 'shelve')$V4
      ),
      end = c(
        subset(os_report, V2 == 'shelve')$V5
      ),
      took_secs = c(
        subset(os_report, V2 == 'shelve')$V8
      )
    )
  )
  idx <- idx + 1
}

params_list <- setNames(params_list,os_list)


get_conn_list <- function(){
  c(
   dbConnect(sqlite, dbname=centos_file),
   dbConnect(sqlite, dbname=windows_file),
   dbConnect(sqlite, dbname=mint_file),
   dbConnect(sqlite, dbname=centosLight_file),
   dbConnect(sqlite, dbname=cirros_file),
   dbConnect(sqlite, dbname=debian_file),
   dbConnect(sqlite, dbname=fedora_file),
   dbConnect(sqlite, dbname=ubuntu_file)
 )
}
