#!/usr/bin/env bash

hosts="/etc/hosts"

echo "The following entries are going to be appended to /etc/hosts in order to block them all:"
for url in "${@}"; do
    echo -e "\t${url}"
done;

echo -e "\nModifying /etc/hosts..."

for url in "${@}"; do
    entry="127.0.0.1\t$url"
    echo -e "\t(*) Appending \"${entry}\"..."
    echo -e "${entry}" | tee -a "${hosts}" 1>/dev/null
done;
