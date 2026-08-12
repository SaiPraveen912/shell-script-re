#!/bin/bash

DOCUMENT="./RHEL_Disk_Usage_Alert.docx"

if [ ! -f "$DOCUMENT" ]
then
    echo "Word document not found"
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
grep -oP '<w:t[^>]*>\K[^<]+' > "$TEXT_FILE"

COUNT=$(grep -i -w "$WORD" "$TEXT_FILE" | wc -l)

echo
echo "================================"
echo "Word Search Result"
echo "================================"
echo "Word  : $WORD"
echo "Count : $COUNT"
echo "================================"

if [ "$COUNT" -eq 0 ]
then
    echo
    echo "Word '$WORD' was not found."
else
    echo
    echo "Found on the following lines:"
    echo "--------------------------------"

    grep -in -w --color=always "$WORD" "$TEXT_FILE"

    echo "--------------------------------"
fi

rm -f "$TEXT_FILE"