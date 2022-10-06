#! /bin/sh

set -eu

PORT=${PORT:-23}
HOST=${HOST:-$USERNAME.your-storagebox.de}

echo "# HELP hetzner_storage_available Available storage"
echo "# TYPE hetzner_storage_available gauge"

echo "# HELP hetzner_storage_used Used storage"
echo "# TYPE hetzner_storage_used gauge"

echo "# HELP hetzner_storage_total Total storage"
echo "# TYPE hetzner_storage_total gauge"

ssh -p${PORT} ${USERNAME}@${HOST} df -k | tail -n +2 | while read FS TOTAL USED AVAIL PERCENT MOUNT; do
   echo "hetzner_storage_available{host=\"${HOST}\"} $AVAIL"
   echo "hetzner_storage_used{host=\"${HOST}\"} $USED"
   echo "hetzner_storage_total{host=\"${HOST}\"} $TOTAL"
done
