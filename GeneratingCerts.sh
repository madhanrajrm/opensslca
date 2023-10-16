#Generate root CA key if not present
if [ ! -f "root.key" ]; then
    echo "Creating Root CA key"
    openssl genrsa -out root.key 4096
fi

#create our self-signed root CA certificate ca.pem if it doesnt exist
if [ ! -f "root.pem" ]; then
    echo "Setting up root CA Cert"
    openssl req -new -x509 -days 1826 -key root.key -out root.pem -subj "/C=IN/ST=KAr/L=BGL/CN=rootCA"
fi

# now create the files required for CRL purposes
touch certindex
echo 01 > certserial
echo 01 > crlnumber

#First, generate the intermediate key:
if [ ! -f "client.key" ] && [ ! -f "server.key" ]; then
    echo "Creating RSA Client & Server Private Key"
    openssl genrsa -out client.key 4096
    openssl genrsa -out server.key 4096
fi

if [ ! -f "client.csr" ] && [ ! -f "server.csr" ]; then
    echo "Creating CSR for RSA server and client key"
    openssl req -new -key server.key -out server.csr -subj "/C=IN/ST=KAr/L=BGL/O=INFY/OU=CISCO/CN=Server"
    openssl req -new -key client.key -out client.csr -subj "/C=IN/ST=KAr/L=BGL/O=INFY/OU=CISCO/CN=Client"
fi

if [ ! -f "client.pem" ] && [ ! -f "server.pem" ]; then
    #Signing the RSA Keys with Root cert
    echo "Signing the RSA server and client CSR with root CA"
    openssl ca -batch -config ca.conf -notext -in client.csr -out client.pem
    openssl ca -batch -config ca.conf -notext -in server.csr -out server.pem
fi

#Generating client and server EC key and CSR
if [ ! -f "serverEC.key" ] && [ ! -f "clientEC.key" ]; then
    echo "Creating EC server and client key"
    openssl ecparam -out serverEC.key -name prime256v1 -genkey
    openssl ecparam -out clientEC.key -name prime256v1 -genkey
fi

if [ ! -f "clientEC.csr" ] && [ ! -f "serverEC.csr" ]; then

    echo "Creating CSR for EC server and client key"
    openssl req -new -key serverEC.key -out serverEC.csr -subj "/C=AC/ST=KAREC/L=BGLEC/O=INFOSYS/OU=CISCEC/CN=serverEC"
    openssl req -new -key clientEC.key -out clientEC.csr -subj "/C=AC/ST=KAREC/L=BGLEC/O=INFOSYS/OU=CISCEC/CN=clientEC"

    #Signing the EC Keys with Root cert
    echo "Signing the EC server and client CSR with root CA"
    openssl ca -batch -config ca.conf -notext -in serverEC.csr -out serverEC.pem
    openssl ca -batch -config ca.conf -notext -in clientEC.csr -out clientEC.pem
fi

if [ ! -f "root.crl" ]; then
    openssl ca -config ca.conf -gencrl -keyfile root.key -cert root.pem -out root.crl.pem
    openssl crl -inform PEM -in root.crl.pem -outform DER -out root.crl
    rm root.crl.pem
fi

rm -rf 0*.pem
for cert in ./*.pem
do
    hash=$(openssl x509 -hash -in "$cert" -noout)
    ln -s $cert $hash.0
done

