#Change to CA top directory
mkdir -p "${CA_PATH}"
cd "${CA_PATH}"

# Create CA folders and files, if not exist
for SUBDIR in certs csr crl newcerts private; do
    mkdir -p "${SUBDIR}"
done
chmod 0700 private
touch index.txt
if [ ! -f serial ];    then echo 1000 > serial;    fi
if [ ! -f crlnumber ]; then echo 1000 > crlnumber; fi

if [ ! -f "${CNFFILE}" ]; then
    cp "/root/${CNFFILE}" .
fi

exit 0

