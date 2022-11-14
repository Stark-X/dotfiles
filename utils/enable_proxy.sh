#!/usr/bin/env bash

proxy_host="127.0.0.1:7890"

if [[ -f ~/.proxy_host ]];then
    proxy_host=`cat ~/.proxy_host`
fi

proxy_prefixes="https_proxy=http://${proxy_host} http_proxy=http://${proxy_host} all_proxy=socks5://${proxy_host}"

cmdline=$@
if [[ ! -z ${cmdline} ]]; then
    eval "${proxy_prefixes} bash -c \"${cmdline}\""
    exit $?
fi

for proxy in ${proxy_prefixes}; do
    eval "export ${proxy}"
done

