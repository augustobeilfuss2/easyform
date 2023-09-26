#configura o sdk do gcloud no projeto
gcloud config set project easyform-397420

#ativa as API's comumente utilizadas no google
gcloud services enable compute.googleapis.com && \
gcloud services enable dns.googleapis.com && \
gcloud services enable sqladmin.googleapis.com && \
gcloud services enable servicenetworking.googleapis.com && \
gcloud services enable cloudbilling.googleapis.com && \
gcloud services enable cloudresourcemanager.googleapis.com && \
gcloud services enable iam.googleapis.com && \
gcloud services enable secretmanager.googleapis.com

#apaga vpc default
#https://cloud.google.com/security-command-center/docs/concepts-vulnerabilities-findings?hl=pt-br#network-findings
gcloud compute firewall-rules delete default-allow-ssh -q
gcloud compute firewall-rules delete default-allow-rdp -q
gcloud compute firewall-rules delete default-allow-icmp -q
gcloud compute firewall-rules delete default-allow-internal -q
gcloud compute networks delete default -q
#cria bucket para o state do terraform
gcloud storage buckets create gs://easyform-bucket