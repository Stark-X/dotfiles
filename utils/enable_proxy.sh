#!/usr/bin/env bash

proxy_prefix="https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"

cmdline=$@
if [[ ! -z ${cmdline} ]]; then
    eval "${proxy_prefix} bash -c \"${cmdline}\""
    exit $?
fi

export ${proxy_prefix}

