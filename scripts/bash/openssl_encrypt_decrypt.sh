#!/bin/bash

echo "Hello World!" > tranlit.txt

openssl aes-256-cbc -a -salt -in translit.txt -out translit.enc -pass pass:123
openssl aes-256-cbc -d -a -in translit.enc -out translit.dec -pass pass:123

cat translit.txt | openssl aes-256-cbc -a -salt -pass pass:123 > translit.enc
cat translit.enc | openssl aes-256-cbc -d -a -pass pass:123 > translit.dec

cat translit.dec
