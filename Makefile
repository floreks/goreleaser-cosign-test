REPO_URL := https://github.com/floreks/goreleaser-cosign-test
OIDC_ISSUER_URL := https://token.actions.githubusercontent.com

.PHONY: verify
verify:
	@read -p "Enter tag version to validate: " tag ;\
	wget "${REPO_URL}/releases/download/$${tag}/checksums.txt" ;\
	cosign verify-blob \
      --certificate-oidc-issuer "${OIDC_ISSUER_URL}" \
      --certificate-github-workflow-name "CD / CLI" \
      --certificate-github-workflow-ref "refs/tags/$${tag}" \
      --certificate "${REPO_URL}/releases/download/$${tag}/checksums.txt.pem" \
      --signature "${REPO_URL}/releases/download/$${tag}/checksums.txt.sig" \
      ./checksums.txt ;\
    rm checksums.txt
