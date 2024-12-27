#!/bin/bash

BOOK_NAME="$1"

SRC_DIR="$(pwd)/${BOOK_NAME}"
TARGET_DIR="$(pwd)/${BOOK_NAME}-target"
TARGET_EPUB="${TARGET_DIR}/${BOOK_NAME}.epub"
TARGET_PDF="${TARGET_DIR}/${BOOK_NAME}.pdf"
MINIFIED_DIR="${TARGET_DIR}/minified"

echo "Minifying resources for ${BOOK_NAME}..."
mkdir -p "${MINIFIED_DIR}"
cp -r "${SRC_DIR}/." "${MINIFIED_DIR}"
for file in $(find "${SRC_DIR}" -type f | grep -E '\.(xhtml|css|ncx|opf|xml)$'); do
    echo "Processing ${file}"
    sed 's|\s\s\s*| |g' "${file}" | tr -d '\n' > "${MINIFIED_DIR}/$(basename "${file}")"
done

echo "Creating epub for ${BOOK_NAME}"
pushd "${MINIFIED_DIR}"
zip -q -X0 "${TARGET_EPUB}" mimetype
zip -q -r "${TARGET_EPUB}" META-INF OEBPS
popd

echo "Verifying epub for ${BOOK_NAME}"
java -jar "./epubcheck-5.1.0/epubcheck.jar" "${TARGET_EPUB}"

echo "Creating pdf for ${BOOK_NAME}"
export QTWEBENGINE_DISABLE_SANDBOX=1
ebook-convert "${TARGET_EPUB}" "${TARGET_PDF}" --paper-size a5 \
              --pdf-serif-family "EB Garamond" --pdf-standard-font serif \
              --pdf-page-margin-top 36 --pdf-page-margin-bottom 36 --pdf-page-margin-left 54 --pdf-page-margin-right 36 \
              --base-font-size 10 \
              --pdf-footer-template '<footer><div style="margin: auto"></div><script>if (_PAGENUM_ >= 3) document.currentScript.parentNode.querySelector("div").innerHTML = "" + (_PAGENUM_ - 2)</script></footer>'
