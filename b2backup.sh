#!/bin/sh

# Backblaze B2 configuration variables
B2_ACCOUNT=""
B2_KEY=""
B2_BUCKET=""

LOGFILE=""
MAILFILE=""
MAILADDRESS=""

export PASSPHRASE=''

# Remove files older than 90 days
#duplicity \
# remove-older-than 90D --force \
# b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}

# Perform the backup
duplicity \
 --log-file ${LOGFILE} \
 --include /storage/backup \
 --include /storage/private \
 --exclude '**' / \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# Cleanup failures
duplicity cleanup \
 --force \
 --log-file ${LOGFILE} \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}

# Show collection-status
duplicity collection-status \
 --log-file ${LOGFILE} \
 b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET} > ${MAILFILE}

# Send email with results
cat ${MAILFILE} | mail -s "B2backup report $(date +%Y-%m-%d)" ${MAILADDRESS}

# Unset variables
unset B2_ACCOUNT
unset B2_KEY
unset B2_BUCKET
unset LOGFILE
unset PASSPHRASE

