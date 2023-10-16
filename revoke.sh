openssl ca -config ca.conf -revoke leaf.pem -keyfile root.key -cert root.pem

if [ -f "root.crl" ]; then
    openssl ca -config ca.conf -gencrl -keyfile root.key -cert root.pem -out root.crl.pem
    openssl crl -inform PEM -in root.crl.pem -outform DER -out root.crl
    rm root.crl.pem
fi

