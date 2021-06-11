#set -x

cd /chia-blockchain

. ./activate

chia init
if [[ ${testnet} == 'true' ]]; then
   echo "configure testnet"
   chia configure --testnet true
   chia configure --set-farmer-peer 62.171.170.55:28447
fi

# https://github.com/Chia-Network/chia-blockchain/wiki/FAQ#why-does-my-node-have-no-connections-how-can-i-get-more-connections
chia configure -upnp false

echo "set debug level"
chia configure -log-level ${LOG_LEVEL}

if [[ ${keys} == "generate" ]]; then
  echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
  chia keys generate
else
  echo "Using keys from file!!!"
  chia keys add -f ${keys}
fi

for p in ${plots_dir//:/ }; do
    mkdir -p ${p}
    if [[ ! "$(ls -A $p)" ]]; then
        echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
    fi
    chia plots add -d ${p}
done

sed -i 's/localhost/127.0.0.1/g' ~/.chia/mainnet/config/config.yaml
# allow for port forward using cloudflare of full node
sed -i 's/self_hostname: 127.0.0.1/self_hostname: 0.0.0.0/g' ~/.chia/mainnet/config/config.yaml
# we need to correct config to proper target address
sed -i 's/xch_target_address: .*/xch_target_address: txch1z9ne4kgxwwuusfgsqx5s745c7zfd5j70nf46sa7l6je2tgcfwunq2fw63n/g' ~/.chia/mainnet/config/config.yaml

chia start harvester


trap : TERM INT; sleep 9999999999d & wait
