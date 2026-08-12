#!/bin/bash

DOCUMENT="./RHEL_Disk_Usage_Alert.docx"

if [ ! -f "$DOCUMENT" ]
then
    echo "Word document not found: $DOCUMENT"
    exit 1
fi

echo "Document found: $DOCUMENT"

WORD=$1

if [ -z "$WORD" ]
then
    echo "Usage: sh word-count.sh <word>"
    exit 1
fi

TEXT_FILE="/tmp/document-text.txt"

unzip -p "$DOCUMENT" word/document.xml |
sed 's/<\/w:p>/\n/g' |
sed 's/<[^>]*>/ /g' |
sed 's/^[[:space:]]*//' |
sed '/^$/d' > "$TEXT_FILE"

COUNT=$(grep -i -w "$WORD" "$TEXT_FILE" | wc -l)

if [ "$COUNT" -eq 0 ]
then
    echo "Word '$WORD' was not found."
else
    echo "Word '$WORD' found $COUNT times."
    echo
    echo "Found on the following lines:"
    grep -in -w "$WORD" "$TEXT_FILE"
fi

rm -f "$TEXT_FILE"