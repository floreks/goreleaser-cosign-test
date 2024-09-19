REPO_URL := https://github.com/floreks/goreleaser-cosign-test/releases/download
OIDC_ISSUER_URL := https://token.actions.githubusercontent.com
VERIFY_FILE_NAME := checksums.txt
VERIFY_TMP_DIR := dist

.PHONY: verify
verify:
	@read -p "Enter version to verify: " tag ;\
	echo "Downloading ${VERIFY_FILE_NAME} for tag v$${tag}..." ;\
	wget -P ${VERIFY_TMP_DIR} "${REPO_URL}/v$${tag}/checksums.txt" >/dev/null 2>&1 ;\
	echo "Verifying signature..." ;\
	COSIGN_EXPERIMENTAL=1 cosign verify-blob \
      --certificate-oidc-issuer "${OIDC_ISSUER_URL}" \
      --certificate-github-workflow-name "CD / CLI" \
      --certificate-github-workflow-ref "refs/tags/v$${tag}" \
      --certificate "${REPO_URL}/v$${tag}/${VERIFY_FILE_NAME}.pem" \
      --signature "${REPO_URL}/v$${tag}/${VERIFY_FILE_NAME}.sig" \
      "./${VERIFY_TMP_DIR}/${VERIFY_FILE_NAME}" ;\
    echo "Verifying archives..." ;\
    wget -P ${VERIFY_TMP_DIR} "${REPO_URL}/v$${tag}/goreleaser-cosign-test_$${tag}_Darwin_amd64.tar.gz" >/dev/null 2>&1 ;\
    wget -P ${VERIFY_TMP_DIR} "${REPO_URL}/v$${tag}/goreleaser-cosign-test_$${tag}_Darwin_arm64.tar.gz" >/dev/null 2>&1 ;\
    wget -P ${VERIFY_TMP_DIR} "${REPO_URL}/v$${tag}/goreleaser-cosign-test_$${tag}_Linux_amd64.tar.gz" >/dev/null 2>&1 ;\
    wget -P ${VERIFY_TMP_DIR} "${REPO_URL}/v$${tag}/goreleaser-cosign-test_$${tag}_Linux_arm64.tar.gz" >/dev/null 2>&1 ;\
    wget -P ${VERIFY_TMP_DIR} "${REPO_URL}/v$${tag}/goreleaser-cosign-test_$${tag}_Windows_amd64.tar.gz" >/dev/null 2>&1 ;\
    (cd ${VERIFY_TMP_DIR} && exec sha256sum --ignore-missing -c checksums.txt) ;\
    rm -r "${VERIFY_TMP_DIR}"
