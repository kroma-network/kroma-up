printf "\nSetting up kzg_params...\n"
sudo apt install axel -y
degree=21
agg_degree=26

params_dir="params/kzg_params"
mkdir -p "$params_dir"

degree_output_file="$params_dir"/params"${degree}"
agg_degree_output_file="$params_dir"/params"${agg_degree}"
rm -f "$degree_output_file"
rm -f "$agg_degree_output_file"

axel -ac https://trusted-setup-halo2kzg.s3.eu-central-1.amazonaws.com/perpetual-powers-of-tau-raw-"$degree" -o "$degree_output_file"
axel -ac https://trusted-setup-halo2kzg.s3.eu-central-1.amazonaws.com/perpetual-powers-of-tau-raw-"$agg_degree" -o "$agg_degree_output_file"
printf "\nInstalled kzg_params \n"