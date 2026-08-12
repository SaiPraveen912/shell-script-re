#!/bin/bash

DOCUMENT="./RHEL_Disk_Usage_Alert.docx"

if [ ! -f "$DOCUMENT" ]
then
    echo "ERROR: Word document not found: $DOCUMENT"
    exit 1
fi

echo "Document found: $DOCUMENT"

WORD=$1

if [ -z "$WORD" ]
then
    echo "Usage: sh 24-word-count.sh <word>"
    exit 1
fi

TEXT_FILE="/tmp/document-text.txt"

unzip -p "$DOCUMENT" word/document.xml |
sed 's/<w:tr[^>]*>/\n/g' |
sed 's/<\/w:tr>/\n/g' |
sed 's/<\/w:tc>/ | /g' |
sed 's/<\/w:p>/\n/g' |
sed 's/<[^>]*>/ /g' |
sed 's/&gt;/>/g' |
sed 's/&lt;/</g' |
sed 's/&amp;/\&/g' |
sed 's/^[[:space:]]*//' |
sed 's/[[:space:]]*$//' |
sed '/^$/d' > "$TEXT_FILE"

COUNT=$(grep -i -w "$WORD" "$TEXT_FILE" | wc -l)

echo
echo "========================================"
echo "          Word Search Result"
echo "========================================"
echo "Word  : $WORD"
echo "Count : $COUNT"
echo "========================================"

if [ "$COUNT" -eq 0 ]
then
    echo
    echo "Word '$WORD' was not found."
else
    echo
    echo "Found on the following lines:"
    echo "----------------------------------------"

    grep -in -w "$WORD" "$TEXT_FILE" |
    while IFS=: read -r LINE CONTENT
    do
        HIGHLIGHTED=$(echo "$CONTENT" | sed "s/\b$WORD\b/\x1b[1;33m&\x1b[0m/Ig")
        echo -e "Line $LINE : $HIGHLIGHTED"
    done

    echo "----------------------------------------"
fi

rm -f "$TEXT_FILE"